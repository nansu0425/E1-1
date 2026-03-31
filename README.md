# E1-1 개발 워크스테이션 구축

## 1. 프로젝트 개요
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
## 4. 터미널 조작 로그

```bash
# 현재 위치 확인
$ pwd
/home/nansu0425/Documents/projects/E1-1

# 목록 확인 (숨김 파일 포함)
$ ls -la
total 44
drwxrwxr-x 7 nansu0425 nansu0425 4096 Mar 31 15:14 .
drwxrwxr-x 3 nansu0425 nansu0425 4096 Mar 31 07:33 ..
drwxrwxr-x 2 nansu0425 nansu0425 4096 Mar 31 08:08 app
drwxrwxr-x 2 nansu0425 nansu0425 4096 Mar 31 07:59 .claude
-rw-rw-r-- 1 nansu0425 nansu0425 6176 Mar 31 15:14 CLAUDE.md
drwxrwxr-x 2 nansu0425 nansu0425 4096 Mar 31 07:35 docs
drwxrwxr-x 8 nansu0425 nansu0425 4096 Mar 31 15:18 .git
-rw-rw-r-- 1 nansu0425 nansu0425   45 Mar 31 08:08 .gitignore
-rw-rw-r-- 1 nansu0425 nansu0425 2703 Mar 31 14:49 README.md
drwxrwxr-x 2 nansu0425 nansu0425 4096 Mar 31 14:24 screenshots

# 실습용 디렉토리 생성
$ mkdir -p practice/subdir

# 디렉토리 이동
$ cd practice
$ pwd
/home/nansu0425/Documents/projects/E1-1/practice

$ cd ..
$ pwd
/home/nansu0425/Documents/projects/E1-1

# 빈 파일 생성
$ touch practice/empty.txt

# 내용이 있는 파일 생성
$ echo "Hello, Codyssey!" > practice/hello.txt

# 파일 내용 확인
$ cat practice/hello.txt
Hello, Codyssey!

# 파일 복사
$ cp practice/hello.txt practice/hello_backup.txt

# 파일 이동 (이름 변경)
$ mv practice/hello_backup.txt practice/subdir/renamed.txt

# 디렉토리 목록으로 확인
$ ls -la practice/
total 16
drwxrwxr-x 3 nansu0425 nansu0425 4096 Mar 31 15:23 .
drwxrwxr-x 8 nansu0425 nansu0425 4096 Mar 31 15:22 ..
-rw-rw-r-- 1 nansu0425 nansu0425    0 Mar 31 15:23 empty.txt
-rw-rw-r-- 1 nansu0425 nansu0425   17 Mar 31 15:23 hello.txt
drwxrwxr-x 2 nansu0425 nansu0425 4096 Mar 31 15:23 subdir

$ ls -la practice/subdir/
total 12
drwxrwxr-x 2 nansu0425 nansu0425 4096 Mar 31 15:23 .
drwxrwxr-x 3 nansu0425 nansu0425 4096 Mar 31 15:23 ..
-rw-rw-r-- 1 nansu0425 nansu0425   17 Mar 31 15:23 renamed.txt

# 파일 삭제
$ rm practice/subdir/renamed.txt

# 디렉토리 삭제
$ rm -r practice/subdir

# 최종 상태 확인
$ ls -la practice/
total 12
drwxrwxr-x 2 nansu0425 nansu0425 4096 Mar 31 15:23 .
drwxrwxr-x 8 nansu0425 nansu0425 4096 Mar 31 15:22 ..
-rw-rw-r-- 1 nansu0425 nansu0425    0 Mar 31 15:23 empty.txt
-rw-rw-r-- 1 nansu0425 nansu0425   17 Mar 31 15:23 hello.txt
```
## 5. 권한 실습

### 파일 권한 변경

**변경 전:**

```bash
$ echo "permission test" > practice/perm_test.txt
$ ls -l practice/perm_test.txt
-rw-rw-r-- 1 nansu0425 nansu0425 16 Mar 31 15:31 practice/perm_test.txt
```

**변경 후 (chmod 755):**

```bash
$ chmod 755 practice/perm_test.txt
$ ls -l practice/perm_test.txt
-rwxr-xr-x 1 nansu0425 nansu0425 16 Mar 31 15:31 practice/perm_test.txt
```

### 디렉토리 권한 변경

**변경 전:**

```bash
$ mkdir practice/perm_dir
$ ls -ld practice/perm_dir
drwxrwxr-x 2 nansu0425 nansu0425 4096 Mar 31 15:32 practice/perm_dir
```

**변경 후 (chmod 700):**

```bash
$ chmod 700 practice/perm_dir
$ ls -ld practice/perm_dir
drwx------ 2 nansu0425 nansu0425 4096 Mar 31 15:32 practice/perm_dir
```

### 권한 숫자 설명

| 권한 | 숫자 | 의미 |
|------|------|------|
| `rw-rw-r--` | 664 | 소유자/그룹: 읽기+쓰기, 기타: 읽기만 (Ubuntu 기본 파일 권한) |
| `rwxr-xr-x` | 755 | 소유자: 모든 권한, 그룹/기타: 읽기+실행 (실행 파일, 디렉토리 기본값) |
| `rwx------` | 700 | 소유자만 모든 권한, 그룹/기타: 접근 불가 (비공개 디렉토리) |

- 각 자리는 읽기(r=4), 쓰기(w=2), 실행(x=1)의 합으로 표현
- 세 자리 숫자는 순서대로 소유자(owner), 그룹(group), 기타(others)의 권한을 나타냄

## 6. Docker 설치 및 기본 점검
## 7. Docker 기본 운영
## 8. 컨테이너 실행 실습
## 9. Dockerfile 커스텀 이미지
## 10. 포트 매핑 접속 증거
## 11. 바인드 마운트 및 볼륨 영속성
## 12. Git 설정 및 GitHub 연동

### Git 설정 확인

```bash
$ git config --list
user.name=nansu0425
user.email=nansu0425@gmail.com
init.defaultbranch=main
core.repositoryformatversion=0
core.filemode=true
core.bare=false
core.logallrefupdates=true
remote.origin.url=https://github.com/nansu0425/E1-1.git
remote.origin.fetch=+refs/heads/*:refs/remotes/origin/*
branch.main.remote=origin
branch.main.merge=refs/heads/main
```

### GitHub 연동

![VSCode GitHub 연동](screenshots/VSCode-Github-연동.png)

### GitHub SSH 키 설정 (보너스)

```bash
$ ssh-keygen -t ed25519 -C "nansu0425@gmail.com"
Generating public/private ed25519 key pair.
Enter file in which to save the key (/home/nansu0425/.ssh/id_ed25519):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/nansu0425/.ssh/id_ed25519
Your public key has been saved in /home/nansu0425/.ssh/id_ed25519.pub
The key fingerprint is:
SHA256:oAKk1kPhHsVFAA7FyPT5e20x+74x/jcYV3Fx5VyAK8Y nansu0425@gmail.com

$ cat ~/.ssh/id_ed25519.pub
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICfkXP201tQWcUnQA6DviZRSCEYHM9qd2ZnrdB9Y0zZ3 nansu0425@gmail.com

$ ssh -T git@github.com
Hi nansu0425! You've successfully authenticated, but GitHub does not provide shell access.

$ git remote set-url origin git@github.com:nansu0425/E1-1.git

$ git remote -v
origin	git@github.com:nansu0425/E1-1.git (fetch)
origin	git@github.com:nansu0425/E1-1.git (push)

$ git push origin main
To github.com:nansu0425/E1-1.git
   5010658..df4841f  main -> main
```

## 13. 트러블슈팅
