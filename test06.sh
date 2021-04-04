#!/bin/dash
# Test script for girt-checkout 
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
    ./girt-checkout 
    echo $?
    # Test for existing commit
    ./girt-init 
    ./girt-checkout
    echo $?
    echo yo >a
    ./girt-add a 
    ./girt-commit -m 'asd'
    # usage errors
    ./girt-checkout 
    echo $?
    ./girt-checkout b1 b2 
    echo $?
    # can't switch to itself
    ./girt-checkout master
    echo $?
    # non existent branches
    ./girt-checkout b1 
    echo $?
    # Test the branch we are switching to is updated with the files in cwd
    ./girt-branch b1
    echo hello >>a
    ./girt-checkout b1
    echo $?
    cat a 
    ./girt-show :a 
    ./girt-show 0:a 
    ./girt-status
    # When switching back nothing should have changed
    ./girt-checkout master 
    echo $?
    cat a 
    ./girt-show :a 
    ./girt-show 0:a
    ./girt-status
    # There is only one index in the whole repo
    ./girt-add a 
    ./girt-status
    ./girt-checkout b1
    echo $?
    ./girt-status
    ./girt-checkout master
    echo $?
    # When branches commit differ than the new cwd will be the latest commit of the new branch
    ./girt-commit -a -m 'asd'
    cat a 
    ./girt-show :a 
    ./girt-show 0:a
    ./girt-checkout b1 
    echo $?
    cat a 
    ./girt-show :a 
    ./girt-show 0:a
    

) >>"output.txt" 2>>"output.txt"
mkdir "solution"
cd "solution"
(
        # Test for a non-existent .girt repo
    2041 girt-checkout 
    echo $?
    # Test for existing commit
    2041 girt-init 
    2041 girt-checkout
    echo $?
    echo yo > a
    2041 girt-add a 
    2041 girt-commit -m 'asd'
    # usage errors
    2041 girt-checkout 
    echo $?
    2041 girt-checkout b1 b2 
    echo $?
    # can't switch to itself
    2041 girt-checkout master
    echo $?
    # non existent branches
    2041 girt-checkout b1 
    echo $?
    # Test the branch we are switching to is updated with the files in cwd
    2041 girt-branch b1
    echo hello >> a
    2041 girt-checkout b1
    echo $?
    cat a 
    2041 girt-show :a 
    2041 girt-show 0:a 
    2041 girt-status
    # When switching back nothing should have changed
    2041 girt-checkout master 
    echo $?
    cat a 
    2041 girt-show :a 
    2041 girt-show 0:a
    2041 girt-status
    # There is only one index in the whole repo
    2041 girt-add a 
    2041 girt-status
    2041 girt-checkout b1
    echo $?
    2041 girt-status
    2041 girt-checkout master
    echo $?
    # When branches commit differ than the new cwd will be the latest commit of the new branch
    2041 girt-commit -a -m 'asd'
    cat a 
    2041 girt-show :a 
    2041 girt-show 0:a
    2041 girt-checkout b1 
    echo $?
    cat a 
    2041 girt-show :a 
    2041 girt-show 0:a

) >>"output.txt" 2>>"output.txt"
cd ..
NC='\033[0m' # No Color
diff -s "output.txt" "solution/output.txt" >/dev/null 2>/dev/null
if [ $? -eq 0 ]
then
    GREEN='\033[0;32m';
    echo "Test06 (girt-checkout)  -${GREEN}PASSED${NC}"
else
    RED='\033[0;31m';
    echo "Test06 (girt-checkout)  -${RED}FAILED${NC}"
    echo "<<<<<< Your answer on the left <<<<<<<                          >>>>>> Solution on the right >>>>>>>>"
    diff -y "output.txt" "solution/output.txt"
fi