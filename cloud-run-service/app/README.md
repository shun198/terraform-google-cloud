## How to send a message to a topic
## Local
```
curl -X POST http://localhost:8080 \
  -H "Content-Type: application/json" \
  -d '{
    "message": {
      "data": "eyJkYXRhIjogIkhlbGxvIn0="
    }
  }'
```

## GCloud
### Send message
```
gcloud pubsub topics publish ${var.project}-topic --message='{"data":"Hello"}'
```