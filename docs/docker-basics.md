# Docker 기초

Docker 설치 점검, 기본 운영 명령, 컨테이너 실행 실습을 기록한 문서이다.

## Docker 설치 및 기본 점검

### Docker 버전 확인

```bash
$ docker --version
Docker version 28.2.2, build 28.2.2-0ubuntu1~24.04.1
```

### Docker 데몬 상태 확인

```bash
$ docker info
Server Version: 28.2.2
Storage Driver: overlay2
 Backing Filesystem: extfs
Operating System: Ubuntu 24.04.4 LTS
Kernel Version: 6.17.0-19-generic
Architecture: x86_64
CPUs: 4
Total Memory: 7.709GiB
Docker Root Dir: /var/lib/docker
Default Runtime: runc
```

## Docker 기본 운영

### 이미지 목록 확인

```bash
$ docker images
REPOSITORY    TAG       IMAGE ID       CREATED      SIZE
hello-world   latest    e2ac70e7319a   7 days ago   10.1kB
```

### 컨테이너 목록 확인

```bash
# 실행 중인 컨테이너
$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

# 전체 컨테이너 (종료된 것 포함)
$ docker ps -a
CONTAINER ID   IMAGE         COMMAND    CREATED          STATUS                      PORTS     NAMES
014e4d3b9c69   hello-world   "/hello"   19 seconds ago   Exited (0) 18 seconds ago             kind_greider
```

### 컨테이너 로그 확인

```bash
$ docker logs my-ubuntu
bin
boot
dev
etc
home
lib
lib64
media
mnt
opt
proc
root
run
sbin
srv
sys
tmp
usr
var
Hello from container!
```

### 컨테이너 리소스 확인

```bash
$ docker run -d --name stats-test ubuntu sleep 60
2b4ab49c30229993f3d5d35b39a15719aa280dc171b799027c2db9729a78bc1a

$ docker stats --no-stream
CONTAINER ID   NAME         CPU %     MEM USAGE / LIMIT   MEM %     NET I/O         BLOCK I/O   PIDS
2b4ab49c3022   stats-test   0.00%     448KiB / 7.709GiB   0.01%     2.76kB / 126B   0B / 0B     1
```

## 컨테이너 실행 실습

### hello-world 실행

```bash
$ docker run hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
4f55086f7dd0: Pull complete
Digest: sha256:452a468a4bf985040037cb6d5392410206e47db9bf5b7278d281f94d1c2d0931
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```

### ubuntu 컨테이너 실행

```bash
$ docker pull ubuntu
Using default tag: latest
latest: Pulling from library/ubuntu
817807f3c64e: Pull complete
Digest: sha256:186072bba1b2f436cbb91ef2567abca677337cfc786c86e107d25b7072feef0c
Status: Downloaded newer image for ubuntu:latest

$ docker run -it --name my-ubuntu ubuntu bash
# ls
bin  boot  dev  etc  home  lib  lib64  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
# echo "Hello from container!"
Hello from container!
# exit
```

### attach와 exec 차이

```bash
# 백그라운드로 ubuntu 컨테이너 실행
$ docker run -dit --name attach-test ubuntu bash

# attach: 메인 프로세스(PID 1)에 연결
$ docker attach attach-test
# exit
# → 컨테이너 종료됨

$ docker ps -a --filter name=attach-test
CONTAINER ID   IMAGE    COMMAND   CREATED   STATUS                     NAMES
1d43054c5e74   ubuntu   "bash"    ...       Exited (137) 1 second ago  attach-test

# 컨테이너 재시작
$ docker start attach-test

# exec: 새 프로세스로 진입
$ docker exec -it attach-test bash
# echo "exec test"
exec test
# exit
# → 컨테이너 계속 실행 중

$ docker ps --filter name=attach-test
CONTAINER ID   IMAGE    COMMAND   CREATED   STATUS         NAMES
1d43054c5e74   ubuntu   "bash"    ...       Up 4 seconds   attach-test
```

**attach와 exec의 차이점:**

- `docker attach`: 컨테이너의 메인 프로세스(PID 1)에 직접 연결된다. `exit`으로 나가면 메인 프로세스가 종료되므로 컨테이너도 함께 종료된다.
- `docker exec`: 컨테이너 안에 새로운 프로세스를 생성하여 진입한다. `exit`으로 나가면 해당 프로세스만 종료되고, 메인 프로세스(PID 1)는 영향을 받지 않으므로 컨테이너는 계속 실행된다.

### 실습 컨테이너 정리

```bash
$ docker rm -f my-ubuntu stats-test attach-test
my-ubuntu
stats-test
attach-test

$ docker ps -a
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```
