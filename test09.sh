#!/bin/dash
# Test script for girt-merge with commits from different branches
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
    seq 1 10 >p.txt
    ./girt-add p.txt
    ./girt-commit -m commit-0
    ./girt-branch b1
    ./girt-checkout b1
    seq 10 20 >p.txt
    ./girt-commit -a -m commit-1
    ./girt-checkout master
    seq 20 30 >p.txt
    ./girt-commit -a -m commit-2
    # Test merging from a previous commit
    ./girt-merge 0 -m message
    # Test merging from a different branch commit
    ./girt-merge 1 -m message
    # Test merging current commit
    ./girt-merge 2 -m message
    ./girt-checkout b1 
    # Test merging from a different branch commit
    ./girt-merge 0 -m message
    # Test merging from current commit
    ./girt-merge 1 -m message
    # Test merging a different branch commit
    ./girt-merge 2 -m message
    
) >>"output.txt" 2>>"output.txt"

mkdir "solution"
cd "solution"
(
    2041 girt-init
    seq 1 10 >p.txt
    2041 girt-add p.txt
    2041 girt-commit -m commit-0
    2041 girt-branch b1
    2041 girt-checkout b1
    seq 10 20 >p.txt
    2041 girt-commit -a -m commit-1
    2041 girt-checkout master
    seq 20 30 >p.txt
    2041 girt-commit -a -m commit-2
    # Test merging from a previous commit
    2041 girt-merge 0 -m message
    # Test merging from a different branch commit
    2041 girt-merge 1 -m message
    # Test merge conflict
    2041 girt-merge 2 -m message
    2041 girt-checkout b1 
    # Test merging from a previous branch commit
    2041 girt-merge 0 -m message
    # Test merging from current commit
    2041 girt-merge 1 -m message
    # Test merging a different branch commit
    2041 girt-merge 2 -m message
) >>"sol.txt" 2>>"sol.txt"
cd ..
NC='\033[0m' # No Color
diff -s "output.txt" "solution/sol.txt" >/dev/null 2>/dev/null
if [ $? -eq 0 ]
then
    GREEN='\033[0;32m';
    echo "Test09 (girt-merge: Merging commits from different branches) -${GREEN}PASSED${NC}"
else
    RED='\033[0;31m';
    echo "Test09 (girt-merge: Merging commits from different branches) -${RED}FAILED${NC}"
    echo "<<<<<< Your answer on the left <<<<<<<                          >>>>>> Solution on the right >>>>>>>>"
    diff -y "output.txt" "solution/sol.txt"
fi
