FROM ghcr.io/astral-sh/uv:python3.12-alpine

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

COPY pyproject.toml uv.lock ./

# Install dependencies.
RUN uv sync --no-dev

COPY . ./

CMD ["uv", "run", "python", "main.py"]
