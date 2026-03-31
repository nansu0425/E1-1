# E1-1 개발 워크스테이션 구축

## 1. 프로젝트 개요

리눅스 CLI, Docker, Git/GitHub를 활용하여 재현 가능한 개발 워크스테이션을 구축하는 프로젝트이다. 터미널 기본 조작과 파일 권한 관리를 실습하고, Docker로 커스텀 웹 서버 컨테이너를 제작하여 포트 매핑, 바인드 마운트, 볼륨 영속성을 검증한다. 모든 수행 과정은 명령어와 출력 결과로 기록하며, Git으로 버전 관리하고 GitHub에 공개한다.

## 2. 실행 환경

```bash
$ uname -a
Linux nansu0425-VMware-Virtual-Platform 6.17.0-19-generic #19~24.04.2-Ubuntu SMP PREEMPT_DYNAMIC Fri Mar  6 23:08:46 UTC 2 x86_64 x86_64 x86_64 GNU/Linux

$ cat /etc/os-release
PRETTY_NAME="Ubuntu 24.04.4 LTS"
NAME="Ubuntu"
VERSION_ID="24.04"
VERSION="24.04.4 LTS (Noble Numbat)"
VERSION_CODENAME=noble
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=noble
LOGO=ubuntu-logo

$ echo $SHELL
/bin/bash

$ git --version
git version 2.43.0

$ docker --version
Docker version 28.2.2, build 28.2.2-0ubuntu1~24.04.1
```

## 3. 수행 항목 체크리스트

- [x] 터미널 기본 조작 및 폴더 구성
- [x] 권한 변경 실습 (파일 1개 + 디렉토리 1개)
- [x] Docker 설치/점검 (version, info)
- [x] hello-world 실행
- [x] ubuntu 컨테이너 실행 및 내부 명령
- [x] attach/exec 차이 정리
- [x] Dockerfile 커스텀 이미지 빌드/실행
- [x] 포트 매핑 접속 (2회: 8080, 8081)
- [x] 바인드 마운트 변경 반영
- [x] 볼륨 영속성 검증
- [x] Git 설정 + GitHub 연동
- [x] 보안 검토 (민감정보 마스킹)
- [x] (보너스) Docker Compose 멀티 컨테이너 (nginx + Flask + Redis)
- [x] (보너스) 환경 변수 활용 (FLASK_DEBUG, REDIS_HOST)
- [x] (보너스) GitHub SSH 키 설정

## 4. 검증 방법 및 결과 위치

각 수행 항목의 상세 명령어와 출력 결과는 아래 기술 문서에서 확인할 수 있다.

| 수행 항목 | 상세 문서 | 검증 방법 요약 |
|---|---|---|
| 터미널 기본 조작 | [터미널 및 권한 실습](docs/terminal-and-permissions.md#터미널-조작-로그) | pwd, ls, mkdir, cp, mv, rm 명령+출력 기록 |
| 권한 변경 실습 | [터미널 및 권한 실습](docs/terminal-and-permissions.md#권한-실습) | chmod 전/후 ls -l 비교 |
| Docker 설치/점검 | [Docker 기초](docs/docker-basics.md#docker-설치-및-기본-점검) | docker --version, docker info 출력 |
| Docker 기본 운영 | [Docker 기초](docs/docker-basics.md#docker-기본-운영) | docker images, ps, logs, stats 출력 |
| hello-world 실행 | [Docker 기초](docs/docker-basics.md#hello-world-실행) | docker run hello-world 출력 |
| ubuntu 컨테이너 | [Docker 기초](docs/docker-basics.md#ubuntu-컨테이너-실행) | docker run -it ubuntu bash 내부 명령 |
| attach/exec 차이 | [Docker 기초](docs/docker-basics.md#attach와-exec-차이) | attach exit→종료, exec exit→유지 비교 |
| Dockerfile 커스텀 이미지 | [커스텀 이미지](docs/docker-custom-image.md) | docker build + wget 응답 확인 |
| 포트 매핑 접속 | [포트 매핑 및 스토리지](docs/port-mapping-and-storage.md#포트-매핑-접속-증거) | 8080/8081 wget 응답 + 브라우저 스크린샷 |
| 바인드 마운트 | [포트 매핑 및 스토리지](docs/port-mapping-and-storage.md#바인드-마운트) | 호스트 파일 변경 전/후 wget 비교 |
| 볼륨 영속성 | [포트 매핑 및 스토리지](docs/port-mapping-and-storage.md#볼륨-영속성) | 컨테이너 삭제 후 새 컨테이너에서 데이터 읽기 |
| Git 설정 + GitHub 연동 | [Git 설정 및 GitHub 연동](docs/git-setup.md) | git config --list + SSH 인증 |
| 보안 검토 | 전체 문서 | 민감정보 마스킹 확인 |
| Docker Compose 멀티 컨테이너 | [Docker Compose 실습](docs/docker-compose.md) | 3서비스 실행 + wget 응답 확인 |
| 환경 변수 활용 | [Docker Compose 실습](docs/docker-compose.md#4-환경-변수-활용) | FLASK_DEBUG 변경 전/후 비교 |
| GitHub SSH 키 설정 | [Git 설정 및 GitHub 연동](docs/git-setup.md#ssh-키-설정) | SSH 인증 테스트 |

## 5. 트러블슈팅

실습 중 발생한 문제와 해결 과정을 기록했다. 상세 내용은 [트러블슈팅 문서](docs/troubleshooting.md)에서 확인할 수 있다.

| # | 문제 | 원인 | 해결 |
|---|---|---|---|
| 1 | `docker compose` 명령 인식 실패 | Compose V2 플러그인 미설치 | `docker-compose-v2` 패키지 설치 |
| 2 | 바인드 마운트 중 `!`가 `\!`로 저장 | 셸이 `!`를 이스케이프 처리 | heredoc(`cat <<'EOF'`)으로 파일 작성 |
