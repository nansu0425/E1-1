# 포트 매핑 및 스토리지

포트 매핑으로 동일 이미지를 여러 포트에 동시 실행하고, 바인드 마운트와 볼륨 영속성을 검증한 기록이다.

## 포트 매핑 접속 증거

### 동시 실행 (포트 8080, 8081)

```bash
$ docker run -d -p 8080:80 --name my-web-8080 my-web:1.0
45c370906218f40e9f7a039951c43f809d107a68b450a347d387c8010a59f62b

$ docker run -d -p 8081:80 --name my-web-8081 my-web:1.0
a83b0d039e1ab4f333a5a8eba22ecbab2e71c125e8c4bfe711e1c265a6483abb

$ docker ps --filter "name=my-web-808"
CONTAINER ID   IMAGE        COMMAND                  CREATED         STATUS                            PORTS                                     NAMES
a83b0d039e1a   my-web:1.0   "/docker-entrypoint.…"   7 seconds ago   Up 6 seconds (health: starting)   0.0.0.0:8081->80/tcp, [::]:8081->80/tcp   my-web-8081
45c370906218   my-web:1.0   "/docker-entrypoint.…"   8 seconds ago   Up 7 seconds (health: starting)   0.0.0.0:8080->80/tcp, [::]:8080->80/tcp   my-web-8080
```

`-p 호스트포트:컨테이너포트` 옵션으로 하나의 이미지를 서로 다른 포트에 동시 실행할 수 있다.

### curl 응답 확인

```bash
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
</body>
</html>

$ curl -s http://localhost:8081
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>E1-1 Custom Web Server</title>
</head>
<body>
    <h1>Hello, Codyssey!</h1>
    <p>이 페이지는 커스텀 Docker 이미지로 서빙됩니다.</p>
</body>
</html>
```

### 브라우저 접속 스크린샷

![포트 8080, 8081 접속](../screenshots/8080-8081.png)

### 정리

```bash
$ docker rm -f my-web-8080 my-web-8081
my-web-8080
my-web-8081
```

## 바인드 마운트

호스트의 `app/` 디렉토리를 컨테이너의 웹 루트에 마운트하여 파일 변경이 즉시 반영되는지 확인한다.

```bash
$ docker run -d -p 8082:80 --name bind-test \
  -v "$(pwd)/app:/usr/share/nginx/html" my-web:1.0
8d60a938f19a658a532200158aa892b852b01eb35c563c211552042639e7510c
```

**변경 전:**

```bash
$ curl -s http://localhost:8082
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>E1-1 Custom Web Server</title>
</head>
<body>
    <h1>Hello, Codyssey!</h1>
    <p>이 페이지는 커스텀 Docker 이미지로 서빙됩니다.</p>
</body>
</html>
```

**호스트에서 파일 수정:**

```bash
$ echo '<h1>Updated Content!</h1>' > app/index.html
```

**변경 후:**

```bash
$ curl -s http://localhost:8082
<h1>Updated Content\!</h1>
```

호스트에서 파일을 수정하면 컨테이너에 즉시 반영된다. 바인드 마운트는 호스트와 컨테이너가 동일한 파일시스템을 공유하기 때문이다.

**원본 복원 및 정리:**

```bash
# app/index.html을 원래 내용으로 복원
$ docker rm -f bind-test
bind-test
```

## 볼륨 영속성

Docker 볼륨은 컨테이너가 삭제되어도 데이터가 유지되는지 검증한다.

```bash
# 볼륨 생성
$ docker volume create mydata
mydata

# 1단계: 볼륨에 데이터 쓰기
$ docker run -d --name vol-test -v mydata:/data ubuntu sleep infinity
f0aaa075f00def3259dbc014cfc2985c4e6579479785a398e949f641bcbe9af3

$ docker exec vol-test bash -c "echo 'persistent data' > /data/hello.txt"
$ docker exec vol-test cat /data/hello.txt
persistent data

# 2단계: 컨테이너 삭제
$ docker rm -f vol-test
vol-test

# 3단계: 새 컨테이너에 같은 볼륨 연결 → 데이터 확인
$ docker run -d --name vol-test2 -v mydata:/data ubuntu sleep infinity
ca295aa5992b72aa6a9da46d339fe4015b7177cdd76220eca5cc0b417fe46e4f

$ docker exec vol-test2 cat /data/hello.txt
persistent data
```

컨테이너를 삭제해도 볼륨의 데이터는 유지된다. Docker 볼륨은 컨테이너 생명주기와 독립적으로 관리되기 때문이다.

```bash
# 정리
$ docker rm -f vol-test2
vol-test2

$ docker volume rm mydata
mydata
```
