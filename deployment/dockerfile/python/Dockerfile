FROM python:3.7-slim-buster as builder
COPY example/python/requirements.txt /app/requirements.txt
RUN pip install -r /app/requirements.txt

# hadolint ignore=DL3007
FROM gcr.io/distroless/python3-debian10:latest
COPY --from=builder /usr/local/lib/python3.7/site-packages /usr/lib/python3.7/.

WORKDIR /app
COPY --from=builder /usr/local/bin/gunicorn ./gunicorn
COPY example/python/main.py ./main.py
COPY example/python/config.py ./config.py

ENV PYTHONDONTWRITEBYTECODE 1

CMD ["gunicorn", "main:app", "-c", "config.py"]
