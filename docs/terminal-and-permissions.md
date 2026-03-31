# 터미널 및 권한 실습

터미널 기본 명령어 조작과 파일/디렉토리 권한 변경을 실습한 기록이다.

## 터미널 조작 로그

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

## 권한 실습

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
