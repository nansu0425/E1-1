FROM nginx:alpine

LABEL maintainer="nansu0425"
LABEL description="E1-1 커스텀 Nginx 웹 서버"

# 환경 변수 설정
ENV APP_ENV=dev

# 정적 콘텐츠 복사
COPY app/ /usr/share/nginx/html/

# 포트 문서화
EXPOSE 80

# 헬스체크 추가
HEALTHCHECK --interval=30s --timeout=3s \
  CMD wget -qO- http://localhost/ || exit 1
