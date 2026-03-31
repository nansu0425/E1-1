# E1-1 미션 수행 로드맵

> 이 문서의 Phase 0~6을 순서대로 완료하면 MISSION.md의 **모든 필수 요구사항(4.1~4.11)**을 충족합니다.
> Phase 7은 선택 보너스 과제입니다.

---

## 사전 환경 요건

이 로드맵의 모든 명령어는 **Unix 셸(bash/zsh)** 기반으로 작성되어 있습니다.

| OS | 셸 환경 | 비고 |
|---|---|---|
| **Linux** | 기본 터미널 | 그대로 수행 가능 |
| **macOS** | 기본 터미널 (zsh/bash) | 그대로 수행 가능 |
| **Windows** | **WSL** 또는 **Git Bash** | 반드시 Unix 호환 셸에서 수행 (`chmod`, `$(pwd)` 등이 PowerShell/CMD에서는 정상 동작하지 않음) |

| 도구 | 요구 사항 |
|---|---|
| **Docker** | Docker Desktop 또는 OrbStack이 설치 및 실행 중이어야 합니다. (OrbStack 사용 시에도 `docker` CLI 명령은 동일하게 사용 가능) |
| **Git** | 설치 완료 및 PATH 등록 |
| **curl** | 설치 완료 (macOS/Linux 기본 내장, Windows는 Git Bash에 포함) |

---

## Phase 0: 환경 확인 및 프로젝트 초기화

> **목표:** Git/GitHub 설정을 완료하고, 프로젝트 디렉토리 구조와 README 뼈대를 만든다.
>
> **대응 요구사항:** 4.1 (제출 저장소 및 기술 문서), 4.10 (Git 설정 및 GitHub 연동)

### 작업 목록

- [ ] 실행 환경 버전 확인 (OS, Shell, Git, Docker)
- [ ] Git 사용자 정보 및 기본 브랜치 설정
- [ ] GitHub 저장소 생성 및 연동
- [ ] 프로젝트 디렉토리 구조 생성
- [ ] README.md 뼈대 작성
- [ ] .gitignore 생성
- [ ] 초기 커밋 및 푸시

### 실행 명령어

#### 0-1. 실행 환경 확인

```bash
# OS 확인
# ── Linux/WSL ──
uname -a
cat /etc/os-release

# ── macOS ──
uname -a
sw_vers

# ── Windows (PowerShell에서 확인 후 WSL/Git Bash로 전환) ──
# systeminfo | findstr /B /C:"OS Name" /C:"OS Version"

# Shell 확인
echo $SHELL

# Git 버전
git --version

# Docker 버전 (설치되어 있다면)
docker --version
```

#### 0-2. Git 설정

```bash
# 사용자 정보 설정
git config --global user.name "본인 이름"
git config --global user.email "본인 이메일"

# 기본 브랜치를 main으로 설정
git config --global init.defaultBranch main

# 설정 확인
git config --list
```

#### 0-3. GitHub 저장소 생성 및 연동

```bash
# 로컬 저장소 초기화
cd ~/source/repos/Codyssey/E1-1   # 본인 프로젝트 경로
git init

# GitHub에서 저장소를 생성한 후:
git remote add origin https://github.com/<username>/<repo>.git
```

#### 0-4. 프로젝트 디렉토리 구조 생성

```bash
mkdir -p app screenshots
```

목표 구조:

```
E1-1/
├── app/              # 웹 서버 소스코드 (Phase 4에서 작성)
├── docs/
│   ├── MISSION.md
│   └── ROADMAP.md
├── screenshots/      # 스크린샷 증거
├── Dockerfile        # Phase 4에서 작성
├── README.md
└── .gitignore
```

#### 0-5. .gitignore 생성

```bash
cat << 'EOF' > .gitignore
.env
*.log
node_modules/
.DS_Store
Thumbs.db
EOF
```

#### 0-6. README.md 뼈대 작성

최소한 다음 섹션 헤더를 포함하는 README.md를 생성한다:

```markdown
# E1-1 개발 워크스테이션 구축

## 1. 프로젝트 개요
## 2. 실행 환경
## 3. 수행 항목 체크리스트
## 4. 터미널 조작 로그
## 5. 권한 실습
## 6. Docker 설치 및 기본 점검
## 7. Docker 기본 운영
## 8. 컨테이너 실행 실습
## 9. Dockerfile 커스텀 이미지
## 10. 포트 매핑 접속 증거
## 11. 바인드 마운트 및 볼륨 영속성
## 12. Git 설정 및 GitHub 연동
## 13. 트러블슈팅
```

#### 0-7. 초기 커밋

```bash
git add .
git commit -m "Initial commit: 프로젝트 구조 및 README 뼈대 생성"
git push -u origin main
```

### 기록할 증거

| 증거 | README 기록 위치 |
|------|-------------------|
| `git config --list` 출력 (민감정보 마스킹) | §12. Git 설정 및 GitHub 연동 |
| OS/Shell/Git/Docker 버전 출력 | §2. 실행 환경 |
| VSCode GitHub 연동 스크린샷 | §12. Git 설정 및 GitHub 연동 |

---

## Phase 1: 터미널 기본 조작

> **목표:** 터미널 핵심 명령어를 수행하고, 명령어 + 출력 결과를 README에 기록한다.
>
> **대응 요구사항:** 4.2 (터미널 조작 로그 기록)

### 작업 목록

- [ ] 현재 위치 확인 (`pwd`)
- [ ] 목록 확인 — 숨김 파일 포함 (`ls -la`)
- [ ] 디렉토리 생성 (`mkdir`)
- [ ] 파일 생성 (`touch`, `echo`)
- [ ] 디렉토리 이동 (`cd`)
- [ ] 파일 내용 확인 (`cat`)
- [ ] 파일 복사 (`cp`)
- [ ] 파일 이동/이름변경 (`mv`)
- [ ] 파일 및 디렉토리 삭제 (`rm`, `rm -r`)
- [ ] README에 명령+출력 기록
- [ ] 커밋

### 실행 명령어

```bash
# 현재 위치 확인
pwd

# 목록 확인 (숨김 파일 포함)
ls -la

# 실습용 디렉토리 생성
mkdir -p practice/subdir

# 디렉토리 이동
cd practice
pwd
# 예상 출력: .../E1-1/practice

cd ..
pwd
# 예상 출력: .../E1-1

# 빈 파일 생성
touch practice/empty.txt

# 내용이 있는 파일 생성
echo "Hello, Codyssey!" > practice/hello.txt

# 파일 내용 확인
cat practice/hello.txt

# 파일 복사
cp practice/hello.txt practice/hello_backup.txt

# 파일 이동 (이름 변경)
mv practice/hello_backup.txt practice/subdir/renamed.txt

# 디렉토리 목록으로 확인
ls -la practice/
ls -la practice/subdir/

# 파일 삭제
rm practice/subdir/renamed.txt

# 디렉토리 삭제
rm -r practice/subdir

# 최종 상태 확인
ls -la practice/
```

### 기록할 증거

| 증거 | README 기록 위치 |
|------|-------------------|
| 위 모든 명령어 + 출력 결과 (코드블록) | §4. 터미널 조작 로그 |

> **💡 트러블슈팅 메모:** 이 Phase를 포함해 이후 Phase 수행 중 겪은 오류나 예상과 다른 동작이 있다면, 간단히 메모해 두세요. Phase 6에서 트러블슈팅 2건 이상을 README에 작성해야 합니다.

### 커밋 체크포인트

```bash
git add .
git commit -m "Phase 1: 터미널 기본 조작 로그 기록"
```

---

## Phase 2: 파일 권한 실습

> **목표:** 파일/디렉토리 권한을 확인·변경하고, 변경 전/후를 비교하여 기록한다.
>
> **대응 요구사항:** 4.3 (권한 실습 및 증거 기록)
>
> **참고:** `chmod`는 Unix 네이티브 명령입니다. macOS/Linux에서는 그대로 동작하며, Windows에서는 WSL 또는 Git Bash에서 수행하세요. (→ [사전 환경 요건](#사전-환경-요건) 참고)

### 작업 목록

- [x] 파일 권한 확인 (변경 전)
- [x] 파일 권한 변경 및 확인 (변경 후)
- [x] 디렉토리 권한 확인 (변경 전)
- [x] 디렉토리 권한 변경 및 확인 (변경 후)
- [x] 전/후 비교를 README에 기록
- [x] 커밋

### 실행 명령어

#### 2-1. 파일 권한 실습

```bash
# 실습 파일 생성
echo "permission test" > practice/perm_test.txt

# 변경 전 권한 확인
ls -l practice/perm_test.txt
# 예상 출력: -rw-r--r-- (644)

# 권한 변경: 실행 권한 추가 (755)
chmod 755 practice/perm_test.txt

# 변경 후 권한 확인
ls -l practice/perm_test.txt
# 예상 출력: -rwxr-xr-x (755)
```

#### 2-2. 디렉토리 권한 실습

```bash
# 실습 디렉토리 생성
mkdir practice/perm_dir

# 변경 전 권한 확인
ls -ld practice/perm_dir
# 예상 출력: drwxr-xr-x (755)

# 권한 변경: 소유자만 접근 가능 (700)
chmod 700 practice/perm_dir

# 변경 후 권한 확인
ls -ld practice/perm_dir
# 예상 출력: drwx------ (700)
```

### 기록할 증거

| 증거 | README 기록 위치 |
|------|-------------------|
| 파일 권한 변경 전/후 `ls -l` 출력 비교 | §5. 권한 실습 |
| 디렉토리 권한 변경 전/후 `ls -ld` 출력 비교 | §5. 권한 실습 |
| 권한 숫자(644, 755, 700 등)의 의미 간단 설명 | §5. 권한 실습 |

### 커밋 체크포인트

```bash
git add .
git commit -m "Phase 2: 파일 권한 실습 기록"
```

---

## Phase 3: Docker 설치 및 기본 점검

> **목표:** Docker 설치를 확인하고, 기본 운영 명령과 컨테이너 실행을 실습한다.
>
> **대응 요구사항:** 4.4 (Docker 설치 및 기본 점검), 4.5 (Docker 기본 운영 명령), 4.6 (컨테이너 실행 실습)
>
> **사전 조건:** Docker Desktop 또는 OrbStack이 설치 및 실행 중이어야 합니다. (→ [사전 환경 요건](#사전-환경-요건) 참고)

### 작업 목록

- [x] Docker 버전 확인
- [x] Docker 데몬 동작 확인
- [x] hello-world 컨테이너 실행
- [x] 이미지 목록 확인
- [x] ubuntu 컨테이너 실행 및 내부 명령 수행
- [x] 컨테이너 목록 확인 (실행 중 / 전체)
- [x] 컨테이너 로그 확인
- [x] 컨테이너 리소스 확인
- [x] attach와 exec 차이 정리
- [x] README에 기록
- [ ] 커밋

### 실행 명령어

#### 3-1. Docker 설치 점검 (→ 4.4)

```bash
# Docker 버전 확인
docker --version

# Docker 데몬 상태 확인
docker info
```

#### 3-2. hello-world 실행 (→ 4.6)

```bash
# hello-world 이미지 다운로드 및 실행
docker run hello-world
```

#### 3-3. 이미지 및 컨테이너 관리 (→ 4.5)

```bash
# 이미지 목록 확인
docker images

# 컨테이너 목록 확인 (실행 중)
docker ps

# 컨테이너 목록 확인 (전체)
docker ps -a
```

#### 3-4. ubuntu 컨테이너 실습 (→ 4.6)

```bash
# ubuntu 이미지 다운로드
docker pull ubuntu

# ubuntu 컨테이너 실행 및 내부 진입
docker run -it --name my-ubuntu ubuntu bash

# 컨테이너 내부에서 실행:
ls
echo "Hello from container!"
exit
```

#### 3-5. 로그 및 리소스 확인 (→ 4.5)

```bash
# 컨테이너 로그 확인
docker logs my-ubuntu

# 실행 중인 컨테이너 리소스 확인 (Ctrl+C로 종료)
# 먼저 백그라운드 컨테이너를 하나 실행한 뒤 확인
docker run -d --name stats-test ubuntu sleep 60
docker stats --no-stream
```

#### 3-6. attach와 exec 차이 관찰 (→ 4.6)

```bash
# 백그라운드로 ubuntu 컨테이너 실행
docker run -dit --name attach-test ubuntu bash

# attach: 메인 프로세스(PID 1)에 연결 — exit하면 컨테이너 종료
docker attach attach-test
# (내부에서 exit 입력 → 컨테이너 종료됨)

# 다시 실행
docker start attach-test

# exec: 새 프로세스로 진입 — exit해도 컨테이너 유지
docker exec -it attach-test bash
# (내부에서 exit 입력 → 컨테이너 계속 실행 중)

# 확인
docker ps
```

#### 3-7. 정리

```bash
# 실습 컨테이너 정리
docker rm -f my-ubuntu stats-test attach-test
```

### 기록할 증거

| 증거 | README 기록 위치 |
|------|-------------------|
| `docker --version` 출력 | §6. Docker 설치 및 기본 점검 |
| `docker info` 출력 (주요 항목) | §6. Docker 설치 및 기본 점검 |
| `docker run hello-world` 출력 | §8. 컨테이너 실행 실습 |
| `docker images`, `docker ps -a` 출력 | §7. Docker 기본 운영 |
| `docker logs` 출력 | §7. Docker 기본 운영 |
| `docker stats` 출력 | §7. Docker 기본 운영 |
| ubuntu 컨테이너 내부 명령 수행 결과 | §8. 컨테이너 실행 실습 |
| attach/exec 차이점 정리 | §8. 컨테이너 실행 실습 |

### 커밋 체크포인트

```bash
git add .
git commit -m "Phase 3: Docker 설치 점검 및 컨테이너 실습 기록"
```

---

## Phase 4: Dockerfile 커스텀 이미지 제작

> **목표:** 기존 베이스 이미지를 기반으로 커스텀 웹 서버 이미지를 빌드하고 실행한다.
>
> **대응 요구사항:** 4.7 (기존 Dockerfile 기반 커스텀 이미지 제작)

### 작업 목록

- [x] 정적 HTML 파일 작성 (`app/index.html`)
- [x] Dockerfile 작성 (nginx:alpine 기반)
- [x] 이미지 빌드
- [x] 컨테이너 실행 및 동작 확인
- [x] README에 베이스 이미지 선택 이유, 커스텀 포인트, 빌드/실행 결과 기록
- [ ] 커밋

### 실행 명령어

#### 4-1. 웹 콘텐츠 작성

```bash
cat << 'EOF' > app/index.html
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
EOF
```

#### 4-2. Dockerfile 작성

```bash
cat << 'EOF' > Dockerfile
FROM nginx:alpine

LABEL maintainer="본인 이름"
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
EOF
```

**커스텀 포인트 요약:**

| 항목 | 목적 |
|------|------|
| `LABEL` | 이미지 메타데이터 (관리자, 설명) |
| `ENV APP_ENV=dev` | 환경 변수로 실행 모드 구분 |
| `COPY app/` | 커스텀 정적 콘텐츠 배포 |
| `HEALTHCHECK` | 컨테이너 상태 자동 점검 |

#### 4-3. 이미지 빌드 및 실행

```bash
# 이미지 빌드
docker build -t my-web:1.0 .

# 빌드된 이미지 확인
docker images | grep my-web

# 테스트 실행
docker run -d --name my-web-test -p 8080:80 my-web:1.0

# 동작 확인
curl http://localhost:8080

# 테스트 컨테이너 정리
docker rm -f my-web-test
```

### 기록할 증거

| 증거 | README 기록 위치 |
|------|-------------------|
| 베이스 이미지 선택 이유 (nginx:alpine) | §9. Dockerfile 커스텀 이미지 |
| 각 커스텀 포인트의 목적 설명 | §9. Dockerfile 커스텀 이미지 |
| `docker build` 출력 (핵심 부분) | §9. Dockerfile 커스텀 이미지 |
| `docker images` 에서 my-web 확인 | §9. Dockerfile 커스텀 이미지 |
| `curl` 응답 결과 | §9. Dockerfile 커스텀 이미지 |

### 커밋 체크포인트

```bash
git add .
git commit -m "Phase 4: Dockerfile 및 커스텀 웹 서버 이미지 작성"
```

---

## Phase 5: 포트 매핑 및 스토리지

> **목표:** 포트 매핑으로 접속을 확인하고, 바인드 마운트와 볼륨 영속성을 검증한다.
>
> **대응 요구사항:** 4.8 (포트 매핑 및 접속 증거), 4.9 (Docker 볼륨 영속성 검증)

### 작업 목록

- [ ] 포트 매핑 실행 (2개 이상 포트)
- [ ] 브라우저 접속 스크린샷 캡처 (주소창 포함)
- [ ] 바인드 마운트로 호스트 파일 변경 반영 확인
- [ ] Docker 볼륨 생성 및 연결
- [ ] 컨테이너 삭제 후 데이터 유지 확인
- [ ] README에 기록
- [ ] 커밋

### 실행 명령어

#### 5-1. 포트 매핑 (→ 4.8)

```bash
# 포트 8080으로 실행
docker run -d -p 8080:80 --name my-web-8080 my-web:1.0

# 포트 8081로 실행
docker run -d -p 8081:80 --name my-web-8081 my-web:1.0

# curl로 접속 확인
curl http://localhost:8080
curl http://localhost:8081

# ★ 브라우저에서 http://localhost:8080, http://localhost:8081 접속
# ★ 주소창이 보이는 스크린샷을 screenshots/ 폴더에 저장

# 정리
docker rm -f my-web-8080 my-web-8081
```

#### 5-2. 바인드 마운트 (→ 4.9)

> **경로 참고:** `$(pwd)`는 macOS/Linux에서 그대로 동작합니다. Windows의 경우 Git Bash에서는 `//c/Users/사용자명/.../app` 형식의 절대 경로를, PowerShell에서는 `${PWD}/app` 형식을 사용하세요. (→ [사전 환경 요건](#사전-환경-요건) 참고)

```bash
# 바인드 마운트로 실행 (호스트 app/ → 컨테이너 웹 루트)
docker run -d -p 8082:80 --name bind-test \
  -v "$(pwd)/app:/usr/share/nginx/html" my-web:1.0

# 현재 상태 확인
curl http://localhost:8082
# ★ 출력 내용 기록 (변경 전)

# 호스트에서 파일 수정
echo '<h1>Updated Content!</h1>' > app/index.html

# 변경 반영 확인
curl http://localhost:8082
# ★ 출력 내용 기록 (변경 후) — 내용이 바뀌었음을 확인

# 원본 복원
cat << 'EOF' > app/index.html
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
EOF

# 정리
docker rm -f bind-test
```

#### 5-3. 볼륨 영속성 검증 (→ 4.9)

```bash
# 볼륨 생성
docker volume create mydata

# 1단계: 볼륨 연결 후 데이터 쓰기
docker run -d --name vol-test -v mydata:/data ubuntu sleep infinity
docker exec vol-test bash -c "echo 'persistent data' > /data/hello.txt"
docker exec vol-test cat /data/hello.txt
# ★ 출력: persistent data

# 2단계: 컨테이너 삭제
docker rm -f vol-test

# 3단계: 새 컨테이너에 같은 볼륨 연결 → 데이터 확인
docker run -d --name vol-test2 -v mydata:/data ubuntu sleep infinity
docker exec vol-test2 cat /data/hello.txt
# ★ 출력: persistent data (데이터 유지됨!)

# 정리
docker rm -f vol-test2
docker volume rm mydata
```

### 기록할 증거

| 증거 | README 기록 위치 |
|------|-------------------|
| 포트 8080/8081 `curl` 응답 | §10. 포트 매핑 접속 증거 |
| 브라우저 접속 스크린샷 (주소창 포함) | §10. 포트 매핑 접속 증거 |
| 바인드 마운트 변경 전/후 `curl` 비교 | §11. 바인드 마운트 및 볼륨 영속성 |
| 볼륨 데이터 쓰기 → 컨테이너 삭제 → 새 컨테이너에서 읽기 결과 | §11. 바인드 마운트 및 볼륨 영속성 |

### 커밋 체크포인트

```bash
git add .
git commit -m "Phase 5: 포트 매핑, 바인드 마운트, 볼륨 영속성 검증"
```

---

## Phase 6: 문서 마무리 및 보안 검토

> **목표:** README를 완성하고, 보안 검토 후 최종 제출한다.
>
> **대응 요구사항:** 4.1 (기술 문서 완성), 4.11 (보안 및 개인정보 보호)

### 작업 목록

- [x] README 프로젝트 개요 작성
- [x] README 수행 항목 체크리스트 작성
- [x] 각 섹션별 검증 방법(어떤 명령으로 무엇을 확인했는지) + 결과 증거 위치(스크린샷 파일명, 코드블록 등) 링크 정리
- [x] 트러블슈팅 2건 이상 작성 (문제 → 원인 가설 → 확인 → 해결/대안)
- [x] 모든 스크린샷/로그에서 민감정보 마스킹 확인
- [x] README만으로 전체 수행 과정을 파악할 수 있는지 셀프 검토
- [ ] 최종 커밋 및 푸시
- [ ] GitHub 저장소 공개 설정 확인

### 체크리스트 (README에 포함)

```markdown
## 수행 항목 체크리스트
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
```

### 트러블슈팅 작성 가이드

미션 수행 중 겪은 문제 2건 이상을 다음 형식으로 정리한다:

```markdown
### 트러블슈팅 #1: (제목)

**문제:** 어떤 상황에서 어떤 오류/문제가 발생했는지
**원인 가설:** 왜 이런 문제가 생겼을 것이라 추정했는지
**확인:** 어떤 명령/방법으로 원인을 확인했는지
**해결/대안:** 어떻게 해결했는지 (또는 대안을 적용했는지)
```

### 보안 점검 목록

- [ ] `git config --list` 출력에서 이메일 외 민감정보 없는지 확인
- [ ] 스크린샷에 토큰, 비밀번호, 개인키가 노출되지 않았는지 확인
- [ ] `.gitignore`에 `.env` 등 민감 파일이 포함되어 있는지 확인
- [ ] GitHub 저장소에 민감 파일이 올라가지 않았는지 확인

### 최종 제출

```bash
git add .
git commit -m "Phase 6: README 완성 및 최종 제출"
git push origin main
```

---

## Phase 7: 보너스 과제 (선택)

> **목표:** Docker Compose로 멀티 컨테이너 환경을 구성하고, 환경 변수를 활용한다.
>
> **대응 요구사항:** MISSION.md §5 (보너스 과제)
>
> **아키텍처:** nginx (reverse proxy) + Flask API + Redis 3서비스 구성
>
> ```
> [브라우저] → :8080 → [nginx] → /api/ → [Flask] → [Redis]
>                         ↓
>                    / → 정적 HTML
> ```

### 7-1. Docker Compose 기초 (단일 서비스)

> **목표:** 기존 my-web:1.0을 Compose로 실행하고, 운영 명령어를 습득한다.
>
> **대응 요구사항:** Docker Compose 기초, Compose 운영 명령어 습득

**완료 기준:**

- [x] `docker-compose.yml`로 단일 웹 서비스 실행/종료 성공
- [x] `up`, `down`, `ps`, `logs` 명령어 수행 결과 기록

### 7-2. Flask API 서비스 작성

> **목표:** Redis를 사용하는 Flask API 서비스를 만들고 이미지를 빌드한다.

**완료 기준:**

- [x] `api/` 디렉토리에 Flask 앱, 의존성 파일, Dockerfile 작성
- [x] `GET /api/visits` 엔드포인트 구현 — Redis 카운터를 증가시키고 JSON 응답
- [x] 이미지 빌드 성공

### 7-3. 멀티 컨테이너 구성 (3서비스)

> **목표:** nginx + Flask + Redis를 Compose로 함께 실행하고, 컨테이너 간 통신을 확인한다.
>
> **대응 요구사항:** Docker Compose 멀티 컨테이너

**완료 기준:**

- [x] nginx가 `/api/` 요청을 Flask로 프록시하는 설정 작성
- [x] `curl http://localhost:8080` → 정적 페이지 응답
- [x] `curl http://localhost:8080/api/visits` → JSON 카운터 응답
- [x] `app/index.html`에서 방문 카운터 표시 (fetch `/api/visits`)

### 7-4. 환경 변수 활용

> **목표:** 환경 변수로 Flask 설정을 제어하고, 동작 차이를 확인한다.
>
> **대응 요구사항:** 환경 변수 활용

**완료 기준:**

- [x] Compose에서 환경 변수 주입 (FLASK_DEBUG, REDIS_HOST 등)
- [x] 환경 변수 변경 → 동작 변화 확인 및 기록

### 7-5. GitHub SSH 키 설정 (✅ 완료)

- `docs/git-setup.md` 참조

### 기록할 증거

| 증거 | 기록 위치 |
|------|-----------|
| Compose 단일 서비스 실행/종료 로그 | `docs/docker-compose.md` |
| Flask API Dockerfile 및 빌드 결과 | `docs/docker-compose.md` |
| 3서비스 실행 + curl 응답 결과 | `docs/docker-compose.md` |
| 환경 변수 변경 전/후 동작 비교 | `docs/docker-compose.md` |
| 트러블슈팅 (발생 시) | README §5 |

### 커밋 체크포인트

Phase 7 완료 후 커밋 및 푸시한다.

---

## 요구사항 매핑표

| 요구사항 | Phase | 완료 |
|----------|-------|------|
| 4.1 제출 저장소 및 기술 문서 | 0, 6 | [ ] |
| 4.2 터미널 조작 로그 기록 | 1 | [ ] |
| 4.3 권한 실습 및 증거 기록 | 2 | [ ] |
| 4.4 Docker 설치 및 기본 점검 | 3 | [ ] |
| 4.5 Docker 기본 운영 명령 수행 | 3 | [ ] |
| 4.6 컨테이너 실행 실습 | 3 | [ ] |
| 4.7 Dockerfile 커스텀 이미지 제작 | 4 | [ ] |
| 4.8 포트 매핑 및 접속 증거 | 5 | [ ] |
| 4.9 Docker 볼륨 영속성 검증 | 5 | [ ] |
| 4.10 Git 설정 및 GitHub 연동 | 0 | [ ] |
| 4.11 보안 및 개인정보 보호 | 6 | [ ] |
| (보너스) Docker Compose | 7 | [ ] |
| (보너스) 환경 변수 활용 | 7 | [ ] |
| (보너스) GitHub SSH 키 | 7 | [ ] |
