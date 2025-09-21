import json
import os

from google.cloud import pubsub_v1

PROJECT_ID = os.getenv("GCP_PROJECT")
TOPIC_ID = os.getenv("PUBSUB_TOPIC")

# https://cloud.google.com/python/docs/reference/pubsub/latest
def main():
    publisher = pubsub_v1.PublisherClient()
    topic_path = publisher.topic_path(PROJECT_ID, TOPIC_ID)

    message = {"data": "Hello from Cloud Run Job!"}
    future = publisher.publish(topic_path, json.dumps(message).encode("utf-8"))
    print(f"Published message ID: {future.result()}")

if __name__ == "__main__":
    main()
