import base64
import json
import logging
import os

from fastapi import FastAPI, HTTPException, Request, status
from fastapi.responses import Response
from google.cloud import firestore, pubsub_v1
from service.firestore import FirestoreService
from service.bq_subscription import SendHistoryToBigQueryService

app = FastAPI()

project = os.environ.get("GCP_PROJECT")

db = firestore.Client(project=project)

collection = db.collection(os.environ.get("FIRESTORE_COLLECTION_NAME"))

topic = db.collection(os.environ.get("PUBSUB_TOPIC_NAME"))

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

firestore_service = FirestoreService(logger, collection)

publisher = pubsub_v1.PublisherClient()

bq_subscription_service = SendHistoryToBigQueryService(logger, publisher, topic)


@app.post("/")
async def index(request: Request):
    """Receive and parse Pub/Sub messages."""
    envelope = await request.json()
    logger.info(f"envelope: {envelope}")
    if not envelope:
        msg = "no Pub/Sub message received"
        logger.error(msg)
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=msg)

    if not isinstance(envelope, dict) or "message" not in envelope:
        msg = "invalid Pub/Sub message format"
        logger.error(msg)
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=msg)

    pubsub_message = envelope["message"]
    if isinstance(pubsub_message, dict) and "data" in pubsub_message:
        try:
            decoded_str = base64.b64decode(pubsub_message["data"]).decode("utf-8").strip()
            logger.info(f"decoded_message: {decoded_str}")
            if firestore_service.if_record_exists(decoded_str):
                logger.info("record already exists")
                return Response(status_code=status.HTTP_204_NO_CONTENT)
            logger.info("enter firestore record")
            firestore_service.enter_single_record(decoded_str)
            bq_subscription_service.regist(decoded_str)
            logger.info("request succeeded")
            return Response(status_code=status.HTTP_200_OK)
        except Exception as e:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=f"exception happened: {e}")
    else:
        return Response(status_code=status.HTTP_204_NO_CONTENT)
