# Dockerfile 커스텀 이미지

기존 베이스 이미지를 활용하여 커스텀 웹 서버 이미지를 제작한 기록이다.

## 베이스 이미지 선택 이유

`nginx:alpine`을 선택했다. Nginx는 정적 파일 서빙에 최적화된 웹 서버이고, Alpine 리눅스 기반이라 이미지 크기가 약 62MB로 경량이다. 별도의 설정 없이 HTML 파일만 복사하면 바로 웹 서버로 동작한다.

## 커스텀 포인트

| 항목 | 목적 |
|------|------|
| `LABEL` | 이미지 메타데이터 (관리자, 설명) |
| `ENV APP_ENV=dev` | 환경 변수로 실행 모드 구분 |
| `COPY app/` | 커스텀 정적 콘텐츠 배포 |
| `EXPOSE 80` | 컨테이너가 사용하는 포트 문서화 |
| `HEALTHCHECK` | 컨테이너 상태 자동 점검 (30초 간격, 3초 타임아웃) |

## 이미지 빌드

```bash
$ docker build -t my-web:1.0 .
Sending build context to Docker daemon  349.2kB
Step 1/7 : FROM nginx:alpine
alpine: Pulling from library/nginx
Status: Downloaded newer image for nginx:alpine
 ---> d5030d429039
Step 2/7 : LABEL maintainer="nansu0425"
Step 3/7 : LABEL description="E1-1 커스텀 Nginx 웹 서버"
Step 4/7 : ENV APP_ENV=dev
Step 5/7 : COPY app/ /usr/share/nginx/html/
Step 6/7 : EXPOSE 80
Step 7/7 : HEALTHCHECK --interval=30s --timeout=3s   CMD wget -qO- http://localhost/ || exit 1
Successfully built 526c448f9a74
Successfully tagged my-web:1.0
```

## 빌드된 이미지 확인

```bash
$ docker images | grep my-web
my-web        1.0       526c448f9a74   62.2MB
```

## 컨테이너 실행 및 동작 확인

```bash
$ docker run -d --name my-web-test -p 8080:80 my-web:1.0

$ wget -qO- http://localhost:8080
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

## 테스트 컨테이너 정리

```bash
$ docker rm -f my-web-test
my-web-test
```

이미지(`my-web:1.0`)는 Phase 5에서 사용하므로 유지한다.
