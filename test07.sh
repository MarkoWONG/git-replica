#!/bin/dash
# Test script for girt-merge
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
    ./girt-merge
    echo $?
    # Test for existing commit
    ./girt-init 
    ./girt-checkout
    echo $?
    seq 1 10 >p.txt
    ./girt-add p.txt
    ./girt-commit -m 'asd'
    # Usage errors
    ./girt-merge
    echo $?
    ./girt-merge 1 2 3 4
    echo $?
    ./girt-merge 1 -a 3
    echo $?
    ./girt-merge -a
    echo $?
    ./girt-merge master -m 
    echo $?
    # empty messages
    ./girt-merge master -m '    '
    echo $?
    ./girt-merge b1
    echo $?
    # incorrect commit number
    ./girt-merge 1 -m 'asf'
    echo $?
    ./girt-merge 123 -m 'afs'
    echo $?
    # incorrect branch number 
    ./girt-merge a -m 'asf'
    echo $?
    ./girt-merge a223 -m 'qewf'
    echo $?
    
    # nothing to merge
    ./girt-merge 0 -m 'asf'
    echo $?

    #normal merge
    ./girt-add p.txt 
    ./girt-commit -m 'asd'
    ./girt-branch b1 
    ./girt-checkout b1
    seq 10 20 >> p.txt  
    ./girt-add p.txt 
    ./girt-commit -m 'sad'
    ./girt-checkout master 
    ./girt-merge b1 -m 'asf'
    echo $?
    cat p.txt 
    ./girt-show :p.txt

) >>"output.txt" 2>>"output.txt"
mkdir "solution"
cd "solution"
(
    # Test for a non-existent .girt repo
    2041 girt-merge
    echo $?
    # Test for existing commit
    2041 girt-init 
    2041 girt-checkout
    echo $?
    seq 1 10 >p.txt
    2041 girt-add p.txt
    2041 girt-commit -m 'asd'
    # Usage errors
    2041 girt-merge
    echo $?
    2041 girt-merge 1 2 3 4
    echo $?
    2041 girt-merge 1 -a 3
    echo $?
    2041 girt-merge -a
    echo $?
    2041 girt-merge master -m 
    echo $?
    # empty messages
    2041 girt-merge master -m '    '
    echo $?
    2041 girt-merge b1
    echo $?
    # incorrect commit number
    2041 girt-merge 1 -m 'asf'
    echo $?
    2041 girt-merge 123 -m 'afs'
    echo $?
    # incorrect branch number 
    2041 girt-merge a -m 'asf'
    echo $?
    2041 girt-merge a223 -m 'qewf'
    echo $?
    
    # nothing to merge
    2041 girt-merge 0 -m 'asf'
    echo $?

    #normal merge
    2041 girt-add p.txt 
    2041 girt-commit -m 'asd'
    2041 girt-branch b1 
    2041 girt-checkout b1
    seq 10 20 >> p.txt  
    2041 girt-add p.txt 
    2041 girt-commit -m 'sad'
    2041 girt-checkout master 
    2041 girt-merge b1 -m 'asd'
    echo $?
    cat p.txt 
    2041 girt-show :p.txt

) >>"sol.txt" 2>>"sol.txt"
cd ..
NC='\033[0m' # No Color
diff -s "output.txt" "solution/sol.txt" >/dev/null 2>/dev/null
if [ $? -eq 0 ]
then
    GREEN='\033[0;32m';
    echo "Test07 (girt-merge) -${GREEN}PASSED${NC}"
else
    RED='\033[0;31m';
    echo "Test07 (girt-merge) -${RED}FAILED${NC}"
    echo "<<<<<< Your answer on the left <<<<<<<                          >>>>>> Solution on the right >>>>>>>>"
    diff -y "output.txt" "solution/sol.txt"
fi
