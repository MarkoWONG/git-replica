#!/bin/dash
# Test script for girt-init
# Line 5,8,11 are from lecture code
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
    # Test error messages
    ./girt-init 2
    # Test exit code
    echo $?
    ./girt-init a asf afsf
    echo $?
    # Test for first sucessful creation of a repo
    ./girt-init
    echo $?
    # Test error messages order
    ./girt-init a 3 afsf
    echo $?
    # Test prevention of more than one repo per directory
    ./girt-init 
    echo $?
) >>"output.txt" 2>>"output.txt"

mkdir "solution"
cd "solution"
(
    2041 girt-init 2 
    echo $?
    2041 girt-init a asf afsf
    echo $?
    2041 girt-init
    echo $?
    2041 girt-init a 3 afsf
    echo $?
    2041 girt-init
    echo $?
) >>"sol.txt" 2>>"sol.txt"
cd ..
NC='\033[0m' # No Color
diff -s "output.txt" "solution/sol.txt" >/dev/null 2>/dev/null
if [ $? -eq 0 ]
then
    GREEN='\033[0;32m';
    echo "Test girt-init -${GREEN}PASSED${NC}"
else
    RED='\033[0;31m';
    echo "Test girt-init -${RED}FAILED${NC}"
    echo "<<<<<< Your answer on the left <<<<<<<                          >>>>>> Solution on the right >>>>>>>>"
    diff -y "output.txt" "solution/sol.txt"
fi