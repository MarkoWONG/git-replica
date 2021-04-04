#!/bin/dash
# Test script for girt-rm/status (using the cwb latest commit)
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
    ./girt-init
    echo hello > a
    ./girt-add a 
    ./girt-commit -m 'asf'
    ./girt-branch b1 
    ./girt-checkout b1 
    echo world >> a 
    ./girt-add a 
    ./girt-commit -m 'asfd'
    ./girt-checkout master 
    echo line 3 >> a 
    echo yo > b 
    ./girt-add a b 
    ./girt-commit -m 'asf'
    ./girt-checkout b1 
    # Test status is using the latest commit in the current working branch not the most recent commit overall
    ./girt-status 
    ./girt-rm a
    cat a 
    ./girt-show :a

) >>"output.txt" 2>>"output.txt"

mkdir "solution"
cd "solution"
(
    2041 girt-init
    echo hello > a
    2041 girt-add a 
    2041 girt-commit -m 'asf'
    2041 girt-branch b1 
    2041 girt-checkout b1 
    echo world >> a 
    2041 girt-add a 
    2041 girt-commit -m 'asfd'
    2041 girt-checkout master 
    echo line 3 >> a 
    # add another file in master but not in b1 to test if checkout removes the file for b1
    echo yo > b 
    2041 girt-add a b 
    2041 girt-commit -m 'asf'
    2041 girt-checkout b1 
    # Test status is using the latest commit in the current working branch not the most recent commit overall
    2041 girt-status 
    # Test rm is using the latest commit in the current working branch not the most recent commit overall
    2041 girt-rm a
    cat a 
    2041 girt-show :a
) >>"output.txt" 2>>"output.txt"
cd ..
NC='\033[0m' # No Color
diff -s "output.txt" "solution/output.txt" >/dev/null 2>/dev/null
if [ $? -eq 0 ]
then
    GREEN='\033[0;32m';
    echo "Test08 (girt-rm/status: using the cwb latest commit) -${GREEN}PASSED${NC}"
else
    RED='\033[0;31m';
    echo "Test08 (girt-rm/status: using the cwb latest commit) -${RED}FAILED${NC}"
    echo "<<<<<< Your answer on the left <<<<<<<                          >>>>>> Solution on the right >>>>>>>>"
    diff -y "output.txt" "solution/output.txt"
fi