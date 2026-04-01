# Docker Compose 멀티 컨테이너 실습

## 아키텍처

```
[브라우저] → :8080 → [nginx] → /api/ → [Flask API] → [Redis]
                       ↓
                  / → 정적 HTML (app/index.html)
```

| 서비스 | 이미지 | 역할 |
|---|---|---|
| web | nginx:alpine | 정적 파일 서빙 + 리버스 프록시 |
| api | python:3.12-alpine (커스텀 빌드) | Flask REST API 서버 |
| redis | redis:7-alpine | 방문 카운터 데이터 저장 |

---

## 1. Docker Compose 기초 — 단일 서비스 실행

### docker-compose.yml 구조

Compose 파일은 `docker run` 명령의 옵션들을 선언적으로 문서화한다. 포트 매핑, 볼륨, 환경 변수, 의존 관계를 한 파일에서 관리할 수 있다.

### Compose 운영 명령어

```bash
# 서비스 빌드 및 백그라운드 실행
$ docker compose up -d --build

# 실행 중인 서비스 확인
$ docker compose ps
NAME           IMAGE            COMMAND                  SERVICE   CREATED         STATUS                            PORTS
e1-1-api-1     e1-1-api         "gunicorn -b 0.0.0.0…"   api       5 seconds ago   Up 4 seconds (health: starting)   5000/tcp
e1-1-redis-1   redis:7-alpine   "docker-entrypoint.s…"   redis     5 seconds ago   Up 4 seconds                      6379/tcp
e1-1-web-1     nginx:alpine     "/docker-entrypoint.…"   web       5 seconds ago   Up 4 seconds                      0.0.0.0:8080->80/tcp, [::]:8080->80/tcp

# 서비스 로그 확인
$ docker compose logs --tail=5
redis-1  | 1:M 31 Mar 2026 09:06:58.759 * Server initialized
redis-1  | 1:M 31 Mar 2026 09:06:58.759 * Ready to accept connections tcp
api-1    | [2026-03-31 09:07:33 +0000] [1] [INFO] Starting gunicorn 23.0.0
api-1    | [2026-03-31 09:07:33 +0000] [1] [INFO] Listening at: http://0.0.0.0:5000 (1)
web-1    | 2026/03/31 09:06:59 [notice] 1#1: start worker processes

# 서비스 종료 및 정리
$ docker compose down
```

**Compose 운영 명령어 요약:**

| 명령 | 설명 |
|---|---|
| `up -d` | 서비스를 백그라운드로 시작 |
| `down` | 서비스 종료 + 컨테이너/네트워크 제거 |
| `ps` | 실행 중인 서비스 상태 확인 |
| `logs` | 서비스 로그 출력 |
| `--build` | 이미지를 다시 빌드 후 실행 |

---

## 2. Flask API 서비스

### 디렉토리 구조

```
api/
├── app.py            # Flask 애플리케이션
├── requirements.txt  # Python 의존성
└── Dockerfile        # API 이미지 빌드 설정
```

### app.py

```python
import os
from flask import Flask, jsonify

app = Flask(__name__)

REDIS_HOST = os.environ.get("REDIS_HOST", "redis")
REDIS_PORT = int(os.environ.get("REDIS_PORT", 6379))

def get_redis():
    import redis
    return redis.Redis(host=REDIS_HOST, port=REDIS_PORT, decode_responses=True)

@app.route("/api/visits")
def visits():
    r = get_redis()
    count = r.incr("visits")
    debug = os.environ.get("FLASK_DEBUG", "0")
    return jsonify({"visits": count, "debug": debug})
```

- `REDIS_HOST`, `REDIS_PORT`를 환경 변수로 주입받아 Redis에 연결한다
- `/api/visits` 호출 시 Redis의 `visits` 키를 증가시키고 JSON으로 응답한다

### api/Dockerfile

```dockerfile
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
```

### 이미지 빌드 결과

```bash
$ docker compose build api
#8 [api 4/5] RUN pip install --no-cache-dir -r requirements.txt
#8 Successfully installed blinker-1.9.0 click-8.3.1 flask-3.1.1 gunicorn-23.0.0
#8 itsdangerous-2.2.0 jinja2-3.1.6 markupsafe-3.0.3 packaging-26.0
#8 redis-5.2.1 werkzeug-3.1.7
```

---

## 3. 멀티 컨테이너 구성 (3서비스)

### docker-compose.yml

```yaml
services:
  web:
    image: nginx:alpine
    ports:
      - "8080:80"
    volumes:
      - ./app:/usr/share/nginx/html:ro
      - ./nginx.conf:/etc/nginx/conf.d/default.conf:ro
    depends_on:
      - api
    restart: unless-stopped

  api:
    build: ./api
    environment:
      - FLASK_DEBUG=0
      - REDIS_HOST=redis
      - REDIS_PORT=6379
    depends_on:
      - redis
    restart: unless-stopped

  redis:
    image: redis:7-alpine
    volumes:
      - redis-data:/data
    restart: unless-stopped

volumes:
  redis-data:
```

### nginx.conf (리버스 프록시)

```nginx
server {
    listen 80;

    location / {
        root /usr/share/nginx/html;
        index index.html;
    }

    location /api/ {
        proxy_pass http://api:5000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

- `/` 요청은 정적 HTML 파일을 서빙한다
- `/api/` 요청은 Flask API 컨테이너(`api:5000`)로 프록시한다
- Compose가 생성하는 내부 네트워크에서 서비스 이름(`api`)으로 DNS 해석이 가능하다

### 동작 검증

```bash
# 정적 페이지 응답
$ curl -s http://localhost:8080
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>E1-1 Custom Web Server</title>
</head>
<body>
    <h1>Hello, Codyssey!</h1>
    <p>이 페이지는 커스텀 Docker 이미지로 서빙됩니다.</p>
    ...
</body>
</html>

# API 엔드포인트 응답 (1회차)
$ curl -s http://localhost:8080/api/visits
{"debug":"0","visits":1}

# API 엔드포인트 응답 (2회차 — 카운터 증가 확인)
$ curl -s http://localhost:8080/api/visits
{"debug":"0","visits":2}
```

- nginx가 `/api/visits` 요청을 Flask로 프록시하고, Flask가 Redis 카운터를 증가시켜 JSON으로 응답한다
- `app/index.html`에서 `fetch('/api/visits')`로 방문 카운터를 표시한다

---

## 4. 환경 변수 활용

### 환경 변수 목록

| 변수 | 기본값 | 용도 |
|---|---|---|
| `FLASK_DEBUG` | `0` | Flask 디버그 모드 제어 |
| `REDIS_HOST` | `redis` | Redis 서비스 호스트명 |
| `REDIS_PORT` | `6379` | Redis 포트 |

### 환경 변수 변경 → 동작 변화 확인

```bash
# 변경 전 (FLASK_DEBUG=0)
$ curl -s http://localhost:8080/api/visits
{"debug":"0","visits":3}

# docker-compose.yml에서 FLASK_DEBUG=0 → FLASK_DEBUG=1로 변경 후 재시작
$ docker compose up -d api
 Container e1-1-api-1  Recreate
 Container e1-1-api-1  Recreated

# 변경 후 (FLASK_DEBUG=1)
$ curl -s http://localhost:8080/api/visits
{
  "debug": "1",
  "visits": 4
}
```

- `FLASK_DEBUG` 환경 변수를 `0`에서 `1`로 변경하면 API 응답의 `debug` 필드가 변경된다
- Redis 볼륨(`redis-data`) 덕분에 컨테이너 재생성 후에도 카운터 데이터(visits=4)가 유지된다
- 코드 수정 없이 환경 변수만으로 애플리케이션 동작을 제어할 수 있다 — **설정과 코드의 분리**

---

## 5. 정리

```bash
$ docker compose down
```

`docker compose down`은 컨테이너와 네트워크를 제거하지만, 명명된 볼륨(`redis-data`)은 유지된다. 볼륨까지 삭제하려면 `docker compose down -v`를 사용한다.
