FROM python:3.7-slim-buster as builder
COPY example/python/requirements.txt /app/requirements.txt
RUN pip3 install -r /app/requirements.txt

# hadolint ignore=DL3007
FROM gcr.io/distroless/python3-debian10:latest
COPY --from=builder /usr/local/lib/python3.7/site-packages /root/.local/lib/python3.7/site-packages
COPY --from=builder /usr/local/bin/gunicorn /app/gunicorn
COPY example/python/server.py /app/server.py
COPY example/python/config.py /app/config.py
ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1

WORKDIR /app
CMD ["gunicorn", "server:app", "-c", "config.py"]
