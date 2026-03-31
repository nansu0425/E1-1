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
## 5. 권한 실습
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
