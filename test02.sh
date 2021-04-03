#!/bin/dash
# Test script for girt-commit
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
    ./girt-commit
    echo $?
    ./girt-init
    # Test for usage cases
    ./girt-commit -a -m 3 4
    ./girt-commit -d -m
    ./girt-commit -m 
    ./girt-commit -a m 
    ./girt-commit -a -m ''
    ./girt-commit -m 
    ./girt-commit -m '    '
    # Test for nothing to commit 
    ./girt-commit -a -m 'commit-message'
    ./girt-commit -m 'commit-message'
    echo hello > a 
    # sucessful commit
    ./girt-add a 
    ./girt-commit -m 'commit-message'
    ./girt-show 0:a
    # No changes committed even when there is other files in cwd
    echo hello world > b
    ./girt-add a 
    ./girt-commit -m 'commit-message'
    ./girt-show 0:b
    # Test removed file with other files still in commit
    ./girt-add b 
    ./girt-commit -m 'commit-message'
    rm a 
    ./girt-add a 
    ./girt-commit -m 'commit-message'
    ./girt-show 2:a
    ./girt-show 2:b
    # Test for -a option which only updates files previously in index
    touch c 
    echo "line 3" >> b;
    ./girt-commit -a -m 'commit-message'
    ./girt-show 2:b
    ./girt-show 2:c

) >>"output.txt" 2>>"output.txt"

mkdir "solution"
cd "solution"
(
       # Test for a non-existent .girt repo
    2041 girt-commit
    echo $?
    2041 girt-init
    # Test for usage cases
    2041 girt-commit -a -m 3 4
    2041 girt-commit -d -m
    2041 girt-commit -m 
    2041 girt-commit -a m 
    2041 girt-commit -a -m ''
    2041 girt-commit -m 
    2041 girt-commit -m '    '
    # Test for nothing to commit 
    2041 girt-commit -a -m 'commit-message'
    2041 girt-commit -m 'commit-message'
    echo hello > a 
    # sucessful commit
    2041 girt-add a 
    2041 girt-commit -m 'commit-message'
    2041 girt-show 0:a
    # No changes committed even when there is other files in cwd
    echo hello world > b
    2041 girt-add a 
    2041 girt-commit -m 'commit-message'
    2041 girt-show 0:b
    # Test removed file with other files still in commit
    2041 girt-add b 
    2041 girt-commit -m 'commit-message'
    rm a 
    2041 girt-add a 
    2041 girt-commit -m 'commit-message'
    2041 girt-show 2:a
    2041 girt-show 2:b
    # Test for -a option
    touch c 
    echo "line 3" >> b;
    2041 girt-commit -a -m 'commit-message'
    2041 girt-show 2:b
    2041 girt-show 2:c

) >>"sol.txt" 2>>"sol.txt"
cd ..
NC='\033[0m' # No Color
diff -s "output.txt" "solution/sol.txt" >/dev/null 2>/dev/null
if [ $? -eq 0 ]
then
    GREEN='\033[0;32m';
    echo "Test girt-commit -${GREEN}PASSED${NC}"
else
    RED='\033[0;31m';
    echo "Test girt-commit -${RED}FAILED${NC}"
    echo "<<<<<< Your answer on the left <<<<<<<                          >>>>>> Solution on the right >>>>>>>>"
    diff -y "output.txt" "solution/sol.txt"
fi