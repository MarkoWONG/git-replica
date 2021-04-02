#!/bin/dash
# Test script for girt-add
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
# Test for a non-existent .girt repo
    ./girt-add
    echo $?
    ./girt-init 
    # Test for usage error
    ./girt-add
    echo $?
    # Test for non-existent files
    ./girt-add a b c d
    echo $?
    # There should be no files added if one file fails
    echo hello > a 
    echo world > b 
    echo line 3 > c 
    ./girt-add a b c d
    echo $?
    ./girt-show :a
    ./girt-show :b
    ./girt-show :c

    touch d 
    # Test for sucessful add
    ./girt-add a b c
    echo $?
    ./girt-show :a
    ./girt-show :b
    ./girt-show :c 
    # Test only added specified files
    ./girt-show :d
    # Test for adding removed files
    rm a b 
    ./girt-add a b
    echo $?
    ./girt-show :a
    ./girt-show :b
    ./girt-show :c 
    
) >>"output.txt" 2>>"output.txt"

mkdir "solution"
cd "solution"
(
    # Test for a non-existent .girt repo
    2041 girt-add
    echo $?
    2041 girt-init 
    # Test for usage error
    2041 girt-add
    echo $?
    # Test for non-existent files
    2041 girt-add a b c d
    echo $?
    # There should be no files added if one file fails
    echo hello > a 
    echo world > b 
    echo line 3 > c 
    2041 girt-add a b c d
    echo $?
    2041 girt-show :a
    2041 girt-show :b
    2041 girt-show :c

    touch d 
    # Test for sucessful add
    2041 girt-add a b c
    echo $?
    2041 girt-show :a
    2041 girt-show :b
    2041 girt-show :c 
    # Test only added specified files
    2041 girt-show :d
    # Test for adding removed files
    rm a b 
    2041 girt-add a b
    echo $?
    2041 girt-show :a
    2041 girt-show :b
    2041 girt-show :c 
    
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