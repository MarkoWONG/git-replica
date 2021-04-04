#!/bin/dash
# Test script for girt-branch 
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
    ./girt-branch
    echo $?
    # Test for existing commit
    ./girt-init 
    ./girt-branch
    echo $?
    touch a 
    ./girt-add a 
    ./girt-commit -m 'asd'
    # list branches when there is only master
    ./girt-branch
    echo $?
    # usage errors
    ./girt-branch -a b1 
    echo $?
    ./girt-branch -a 
    echo $?
    ./girt-branch w s 
    echo $?
    # branch name errors
    ./girt-branch -d 
    echo $?
    ./girt-branch -d 1
    echo $?
    ./girt-branch 2
    echo $?
    # branch name must be unique
    ./girt-branch master 
    echo $?
    ./girt-branch b1 
    echo $?
    ./girt-branch b1 
    echo $?
    # can't delete master
    ./girt-branch -d master 
    echo $?
    # non-existent branch
    ./girt-branch -d b2  
    echo $?
    # list lots of branches
    ./girt-branch b2
    echo $?
    ./girt-branch b3
    echo $?
    ./girt-branch b4
    echo $?
    ./girt-branch 
    echo $?
    # Prevent lost of work
    echo hello > a 
    ./girt-add a 
    ./girt-commit -m 'asf'
    ./girt-checkout b2 
    echo world > a 
    ./girt-add a 
    ./girt-commit -m 'asf'
    ./girt-checkout master
    ./girt-branch -d b2 
    echo $?
) >>"output.txt" 2>>"output.txt"

mkdir "solution"
cd "solution"
(
     # Test for a non-existent .girt repo
    2041 girt-branch
    echo $?
    # Test for existing commit
    2041 girt-init 
    2041 girt-branch
    echo $?
    touch a 
    2041 girt-add a 
    2041 girt-commit -m 'asd'
    # list branches when there is only master
    2041 girt-branch
    echo $?
    # usage errors
    2041 girt-branch -a b1 
    echo $?
    2041 girt-branch -a 
    echo $?
    2041 girt-branch w s 
    echo $?
    # branch name errors
    2041 girt-branch -d 
    echo $?
    2041 girt-branch -d 1
    echo $?
    2041 girt-branch 2
    echo $?
    # branch name must be unique
    2041 girt-branch master 
    echo $?
    2041 girt-branch b1 
    echo $?
    2041 girt-branch b1 
    echo $?
    # can't delete master
    2041 girt-branch -d master 
    echo $?
    # non-existent branch
    2041 girt-branch -d b2  
    echo $?
    # list lots of branches
    2041 girt-branch b2
    echo $?
    2041 girt-branch b3
    echo $?
    2041 girt-branch b4
    echo $?
    2041 girt-branch 
    echo $?
    # Prevent lost of work
    echo hello > a 
    2041 girt-add a 
    2041 girt-commit -m 'asf'
    2041 girt-checkout b2 
    echo world > a 
    2041 girt-add a 
    2041 girt-commit -m 'asf'
    2041 girt-checkout master
    2041 girt-branch -d b2 
    echo $?

) >>"sol.txt" 2>>"sol.txt"
cd ..
NC='\033[0m' # No Color
diff -s "output.txt" "solution/sol.txt" >/dev/null 2>/dev/null
if [ $? -eq 0 ]
then
    GREEN='\033[0;32m';
    echo "Test05 (girt-branch) -${GREEN}PASSED${NC}"
else
    RED='\033[0;31m';
    echo "Test05 (girt-branch) -${RED}FAILED${NC}"
    echo "<<<<<< Your answer on the left <<<<<<<                          >>>>>> Solution on the right >>>>>>>>"
    diff -y "output.txt" "solution/sol.txt"
fi