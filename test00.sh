#!/bin/dash
# Test script for girt-init girt-log girt-show
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
    #Girt-init tests
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

    #Girt-log tests
    #Usage Errors
    ./girt-log 1 
    echo $?
    #no commits
    ./girt-log 
    echo $?
    # normal operation
    touch 1
    ./girt-add 1
    ./girt-commit -m '0'
    ./girt-log
    echo $?
    touch 2
    ./girt-add 2
    ./girt-commit -m '1'
    touch a
    ./girt-add a
    ./girt-commit -m '2'
    touch b
    ./girt-add b
    ./girt-commit -m '3'
    ./girt-log
    echo $?

    # Girt-show tests
    # Usage errors
    ./girt-show 
    echo $?
    ./girt-show 1 2
    echo $?
    # missing a ':'
    ./girt-show 0a
    echo $?
    ./girt-show 3fsf
    echo $?
    # fake files
    ./girt-show :c 
    echo $?
    # fake commit
    ./girt-show 4:a 
    echo $?
    # real commit, fake file
    ./girt-show 2:c 
    echo $?
    # normal operation 
    echo hello > a 
    ./girt-add a 
    ./girt-commit -m '4'
    echo hello_world > a 
    ./girt-add a 
    ./girt-show :a
    echo $?
    ./girt-show 4:a 
    echo $?
    #empty valid file
    ./girt-show 2:a
    echo $?
    #real file but wrong commit
    ./girt-show 2:a
    echo $?


) >>"output.txt" 2>>"output.txt"

mkdir "solution"
cd "solution"
(
    #Girt-init tests
    # Test error messages
    2041 girt-init 2
    # Test exit code
    echo $?
    2041 girt-init a asf afsf
    echo $?
    # Test for first sucessful creation of a repo
    2041 girt-init
    echo $?
    # Test error messages order
    2041 girt-init a 3 afsf
    echo $?
    # Test prevention of more than one repo per directory
    2041 girt-init 
    echo $?

    #Girt-log tests
    #Usage Errors
    2041 girt-log 1 
    echo $?
    #no commits
    2041 girt-log 
    echo $?
    # normal operation
    touch 1
    2041 girt-add 1
    2041 girt-commit -m '0'
    2041 girt-log
    echo $?
    touch 2
    2041 girt-add 2
    2041 girt-commit -m '1'
    touch a
    2041 girt-add a
    2041 girt-commit -m '2'
    touch b
    2041 girt-add b
    2041 girt-commit -m '3'
    2041 girt-log
    echo $?

    # Girt-show tests
    # Usage errors
    2041 girt-show 
    echo $?
    2041 girt-show 1 2
    echo $?
    # missing a ':'
    2041 girt-show 0a
    echo $?
    2041 girt-show 3fsf
    echo $?
    # fake files
    2041 girt-show :c 
    echo $?
    # fake commit
    2041 girt-show 4:a 
    echo $?
    # real commit, fake file
    2041 girt-show 2:c 
    echo $?
    # normal operation 
    echo hello > a 
    2041 girt-add a 
    2041 girt-commit -m '4'
    echo hello_world > a 
    2041 girt-add a 
    2041 girt-show :a
    echo $?
    2041 girt-show 4:a 
    echo $?
    #empty valid file
    2041 girt-show 2:a
    echo $?
    #real file but wrong commit
    2041 girt-show 2:a
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