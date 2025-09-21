import base64
import logging
import os

from fastapi import FastAPI, HTTPException, Request, status
from fastapi.responses import Response
from google.cloud import firestore
from service.firestore import FirestoreService

app = FastAPI()

db = firestore.Client(project=os.environ.get("GCP_PROJECT"))

collection = db.collection(os.environ.get("FIRESTORE_COLLECTION_NAME"))

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

firestore_service = FirestoreService(logger, collection)


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
            decoded_message = base64.b64decode(pubsub_message["data"]).decode("utf-8").strip()
            logger.info(f"decoded_message: {decoded_message}")
            if firestore_service.if_record_exists(decoded_message):
                logger.info("record already exists")
                return Response(status_code=status.HTTP_204_NO_CONTENT)
            firestore_service.enter_single_record(decoded_message)
            return Response(status_code=status.HTTP_200_OK)
        except Exception as e:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=f"exception happened: {e}")
    else:
        return Response(status_code=status.HTTP_204_NO_CONTENT)
