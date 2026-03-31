# 트러블슈팅

## #1: `docker compose` 명령 인식 실패

**문제:** Phase 7에서 `docker compose up` 실행 시 `unknown command` 오류 발생

```bash
$ docker compose version
docker: unknown command: docker compose
```

**원인 가설:** Docker Engine은 설치되어 있지만, Compose V2 플러그인이 별도 패키지로 분리되어 있어 추가 설치가 필요할 것으로 추정

**확인:** `docker help` 출력에서 `compose` 서브커맨드가 목록에 없음을 확인

**해결:** `docker-compose-v2` 패키지를 설치하여 해결

```bash
$ sudo apt-get install -y docker-compose-v2
$ docker compose version
Docker Compose version v2.34.0
```

## #2: 바인드 마운트 테스트 중 `!` 이스케이프 문제

**문제:** Phase 5 바인드 마운트 실습에서 `echo`로 HTML 파일을 수정할 때 `!`가 `\!`로 저장됨

```bash
$ echo '<h1>Updated Content!</h1>' > app/index.html
$ wget -qO- http://localhost:8082
<h1>Updated Content\!</h1>
```

**원인 확인:** `echo`와 `printf`로 `!`를 포함한 문자열을 파일에 쓰면 `\!`(0x5c 0x21)로 기록되는 것을 xxd로 확인했다. 셸이 명령 인자를 처리할 때 `!` 앞에 백슬래시를 삽입하는 것이 원인이다.

```bash
$ echo '<h1>Updated Content!</h1>' > /tmp/test.html
$ xxd /tmp/test.html
00000000: 3c68 313e 5570 6461 7465 6420 436f 6e74  <h1>Updated Cont
00000010: 656e 745c 213c 2f68 313e 0a              ent\!</h1>.
```

**해결:** heredoc(`cat <<'EOF'`)으로 파일을 작성하면 명령 인자가 아닌 별도 입력 스트림으로 처리되어 `!`가 그대로 저장된다.

```bash
$ cat <<'EOF' > /tmp/test_heredoc.html
<h1>Updated Content!</h1>
EOF
$ xxd /tmp/test_heredoc.html
00000000: 3c68 313e 5570 6461 7465 6420 436f 6e74  <h1>Updated Cont
00000010: 656e 7421 3c2f 6831 3e0a                 ent!</h1>.
```
