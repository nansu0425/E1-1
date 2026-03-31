FROM python:3.12-alpine

LABEL maintainer="nansu0425"
LABEL description="E1-1 Flask API 서버"

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

ENV FLASK_DEBUG=0
ENV REDIS_HOST=redis
ENV REDIS_PORT=6379

EXPOSE 5000

HEALTHCHECK --interval=30s --timeout=3s \
  CMD wget -qO- http://localhost:5000/api/visits || exit 1

CMD ["gunicorn", "-b", "0.0.0.0:5000", "app:app"]
