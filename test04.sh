#!/bin/dash
# Test script for girt-status
# Line 5,8,20 are from lecture code
# Make a temp directory for testing
test_dir=$(mktemp -d /tmp/dir.XXXXXXXXXX)

# ensure temporary directory + all its contents removed on exit
trap 'rm -rf "$test_dir; exit"' INT TERM EXIT

# Copy all girt-* files into test_dir
for file in *
do 
    if [ -f "$file" ] && echo "$file" | egrep -q '^girt-.*'
    then 
        cp "./"$file"" ""$test_dir"/"$file"";
    fi
done

# change working directory to the new temporary directory
cd "$test_dir" || exit 1

# Begin tests:
(
    # Test for a non-existent .girt repo
    ./girt-status
    echo $?
    ./girt-init
    # There is no usage errors
    ./girt-status 2 asr 3 d 
    echo $? 
    # Same file in cwd and index and latest commit
    echo hi > a 
    ./girt-add a 
    ./girt-commit -m 'asf'
    ./girt-status 
    echo $?
    # cwd diff to (index and commit)
    echo how > b 
    ./girt-add b 
    ./girt-commit -m 'afs'
    echo is > b 
    ./girt-status 
    echo $?
    # file all different
    echo your > c 
    ./girt-add c 
    ./girt-commit -m 'asf' 
    echo day > c 
    ./girt-add c 
    echo "?" > c 
    ./girt-status 
    echo $?
    # commit diff to (cwd and index)
    echo can > d
    ./girt-add d
    ./girt-commit -m 'asf'
    echo "i" > d
    ./girt-add d
    ./girt-status 
    echo $?
    # index diff to (cwd and commit)
    echo get > e
    ./girt-add e
    ./girt-commit -m 'asf'
    echo "HD?" > e
    ./girt-add e
    echo get > e 
    ./girt-status 
    echo $?
    # same cwd and index but no commit 
    echo please > f 
    ./girt-add f 
    ./girt-status 
    echo $?
    # only in cwd
    echo anime > g 
    ./girt-status 
    echo $?
    # file same in cwd and commit but rm from index 
    echo is > h 
    ./girt-add h 
    ./girt-commit -m 'asf'
    ./girt-rm --cached h 
    ./girt-status 
    echo $?
    # different in cwd compared to index but no commit 
    echo best > i
    ./girt-add i
    echo "!" > i 
    ./girt-status 
    echo $?
    # file different in cwd and commit but rm from index 
    echo help > j
    ./girt-add j
    ./girt-commit -m 'asf'
    ./girt-rm --cached j
    echo me > j 
    ./girt-status 
    echo $?
    # same file in index and commit but rm from cwd 
    echo "I go" > k 
    ./girt-add k 
    ./girt-commit -m 'asf'
    rm k 
    ./girt-status 
    echo $?
    # different file in index and commit but rm from cwd 
    echo brrrr > l 
    ./girt-add l 
    ./girt-commit -m 'asf'
    echo you > l 
    ./girt-add l 
    rm l 
    ./girt-status 
    echo $?
    #only in index 
    echo give > m 
    ./girt-add m 
    rm m 
    ./girt-status 
    echo $?
    #only in latest commit 
    echo me > n 
    ./girt-add n 
    ./girt-commit -m 'asf'
    ./girt-rm n 
    #check status 
    ./girt-status 
    echo $?
    # modify data
    echo "100%" > a
    ./girt-status
    echo $?

) >>"output.txt" 2>>"output.txt"

mkdir "solution"
cd "solution"
(
    # Test for a non-existent .girt repo
    2041 girt-status
    echo $?
    2041 girt-init
    # There is no usage errors
    2041 girt-status 2 asr 3 d 
    echo $? 
    # Same file in cwd and index and latest commit
    echo hi > a 
    2041 girt-add a 
    2041 girt-commit -m 'asf'
    2041 girt-status 
    echo $?
    # cwd diff to (index and commit)
    echo how > b 
    2041 girt-add b 
    2041 girt-commit -m 'afs'
    echo is > b 
    2041 girt-status 
    echo $?
    # file all different
    echo your > c 
    2041 girt-add c 
    2041 girt-commit -m 'asf' 
    echo day > c 
    2041 girt-add c 
    echo "?" > c 
    2041 girt-status 
    echo $?
    # commit diff to (cwd and index)
    echo can > d
    2041 girt-add d
    2041 girt-commit -m 'asf'
    echo i > d
    2041 girt-add d
    2041 girt-status 
    echo $?
    # index diff to (cwd and commit)
    echo get > e
    2041 girt-add e
    2041 girt-commit -m 'asf'
    echo "HD?" > e
    2041 girt-add e
    echo get > e 
    2041 girt-status 
    echo $?
    
    # same cwd and index but no commit 
    echo please > f 
    2041 girt-add f 
    2041 girt-status 
    echo $?
    # only in cwd
    echo anime > g 
    2041 girt-status 
    echo $?
    # file same in cwd and commit but rm from index 
    echo is > h 
    2041 girt-add h 
    2041 girt-commit -m 'asf'
    2041 girt-rm --cached h 
    2041 girt-status 
    echo $?
    # different in cwd compared to index but no commit 
    echo best > i
    2041 girt-add i
    echo "!" > i 
    2041 girt-status 
    echo $?
    # file different in cwd and commit but rm from index 
    echo help > j
    2041 girt-add j
    2041 girt-commit -m 'asf'
    2041 girt-rm --cached j
    echo me > j 
    2041 girt-status 
    echo $?
    # same file in index and commit but rm from cwd 
    echo "I go" > k 
    2041 girt-add k 
    2041 girt-commit -m 'asf'
    rm k 
    2041 girt-status 
    echo $?
    # different file in index and commit but rm from cwd 
    echo brrrr > l 
    2041 girt-add l 
    2041 girt-commit -m 'asf'
    echo you > l 
    2041 girt-add l 
    rm l 
    2041 girt-status 
    echo $?
    #only in index 
    echo give > m 
    2041 girt-add m 
    rm m 
    2041 girt-status 
    echo $?
    #only in latest commit 
    echo me > n 
    2041 girt-add n 
    2041 girt-commit -m 'asf'
    2041 girt-rm n 
    #check status 
    2041 girt-status 
    echo $?
    # modify data
    echo "100%" > a
    2041 girt-status
    echo $?

) >>"output.txt" 2>>"output.txt"
cd ..
NC='\033[0m' # No Color
diff -s "output.txt" "solution/output.txt" >/dev/null 2>/dev/null
if [ $? -eq 0 ]
then
    GREEN='\033[0;32m';
    echo "Test04 (girt-status) -${GREEN}PASSED${NC}"
else
    RED='\033[0;31m';
    echo "Test04( girt-status) -${RED}FAILED${NC}"
    echo "<<<<<< Your answer on the left <<<<<<<                          >>>>>> Solution on the right >>>>>>>>"
    diff -y "output.txt" "solution/output.txt"
fi