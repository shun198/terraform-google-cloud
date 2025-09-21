format:
	uv run ruff format

run:
	uv run uvicorn main:app --port 8080 --reload --host 0.0.0.0

request:
	curl -X POST -H "Content-Type: application/json" -d '{"message": {"data": "eyJkYXRhIjogIkhlbGxvIn0="}}' http://localhost:8080
