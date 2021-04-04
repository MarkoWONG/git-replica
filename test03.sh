#!/bin/dash
# Test script for girt-rm
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
    ./girt-rm
    echo $?
    # Usage Errors
    ./girt-init 
    ./girt-rm 
    echo $?
    ./girt-rm --force 
    echo $?
    ./girt-rm --cached
    echo $?
    ./girt-rm --force --cached
    echo $?
    # no existing commits
    touch a 
    ./girt-add a 
    ./girt-rm a  
    echo $?
    # Tests for preventing work loss 
    # When the file content differ in cwd, latest commit, index
    echo "hello" > a 
    ./girt-add a 
    ./girt-commit -m 'asf'
    echo "world" >> a 
    ./girt-add a 
    echo "HD plz" > a 
    ./girt-rm a 
    echo $?
    ./girt-show :a
    cat a
    # cwd and index vs latest commit
    echo "yo" > b
    ./girt-add b 
    ./girt-commit -m 'afsg'
    echo "marker" >> b 
    ./girt-add b 
    ./girt-rm b 
    echo $?
    ./girt-show :b
    cat b
    # cwd and latest commit vs index
    echo "100%" > c 
    ./girt-add c 
    ./girt-commit -m 'asf'
    echo "for test scripts" > c 
    ./girt-add c 
    echo "100%" > c 
    ./girt-rm c
    echo $?
    ./girt-show :c
    cat c
    # index and latest commit vs cwd
    echo "I sleep" > d 
    ./girt-add d 
    ./girt-commit -m 'asf'
    echo "I woke" > d
    ./girt-rm d
    echo $?
    ./girt-show :d 
    cat d

    # test force option
    ./girt-rm --force a 
    echo $?
    ./girt-rm --force b 
    echo $?
    ./girt-rm --force c
    echo $?
    ./girt-rm --force d
    echo $?
    ./girt-show :a
    ./girt-show :b
    ./girt-show :c
    ./girt-show :d
    cat a
    cat b
    cat c
    cat d

    # test cached option
    # When the file content differ in cwd, latest commit, index
    echo "hello" > a 
    ./girt-add a 
    ./girt-commit -m 'asf'
    echo "world" >> a 
    ./girt-add a 
    echo "HD plz" > a 
    ./girt-rm --cached a 
    echo $?
    ./girt-show :a
    cat a
    # cwd and index vs latest commit
    echo "yo" > b
    ./girt-add b 
    ./girt-commit -m 'afsg'
    echo "marker" >> b 
    ./girt-add b 
    ./girt-rm --cached b 
    echo $?
    ./girt-show :b
    cat b
    # cwd and latest commit vs index (only one to fail)
    echo "100%" > c 
    ./girt-add c 
    ./girt-commit -m 'asf'
    echo "for test scripts" > c 
    ./girt-add c 
    echo "100%" > c 
    ./girt-rm --cached c
    echo $?
    ./girt-show :c
    cat c
    # index and latest commit vs cwd
    echo "I sleep" > d 
    ./girt-add d 
    ./girt-commit -m 'asf'
    echo "I woke" > d
    ./girt-rm --cached d
    echo $?
    ./girt-show :d 
    cat d

    # non existent files 
    ./girt-rm e
    echo $?
    ./girt-rm --cached e
    echo $?
    ./girt-rm --force e
    echo $?

    # using both options
    echo "hello" > a 
    ./girt-add a 
    ./girt-commit -m 'asf'
    echo "world" >> a 
    ./girt-add a 
    echo "HD plz" > a 
    ./girt-rm --force --cached a 
    echo $?
    ./girt-show :a 
    cat a

) >>"output.txt" 2>>"output.txt"

mkdir "solution"
cd "solution"
(
    # Test for a non-existent .girt repo
    2041 girt-rm
    echo $?
    # Usage Errors
    2041 girt-init 
    2041 girt-rm 
    echo $?
    2041 girt-rm --force 
    echo $?
    2041 girt-rm --cached
    echo $?
    2041 girt-rm --force --cached
    echo $?
    # no existing commits
    touch a 
    2041 girt-add a 
    2041 girt-rm a
    echo $?
    # Tests for preventing work loss 
    # When the file content differ in cwd, latest commit, index
    echo "hello" > a 
    2041 girt-add a 
    2041 girt-commit -m 'asf'
    echo "world" >> a 
    2041 girt-add a 
    echo "HD plz" > a 
    2041 girt-rm a 
    echo $?
    2041 girt-show :a
    cat a
    # cwd and index vs latest commit
    echo "yo" > b
    2041 girt-add b 
    2041 girt-commit -m 'afsg'
    echo "marker" >> b 
    2041 girt-add b 
    2041 girt-rm b 
    echo $?
    2041 girt-show :b
    cat b
    # cwd and latest commit vs index
    echo "100%" > c 
    2041 girt-add c 
    2041 girt-commit -m 'asf'
    echo "for test scripts" > c 
    2041 girt-add c 
    echo "100%" > c 
    2041 girt-rm c
    echo $?
    2041 girt-show :c
    cat c
    # index and latest commit vs cwd
    echo "I sleep" > d 
    2041 girt-add d 
    2041 girt-commit -m 'asf'
    echo "I woke" > d
    2041 girt-rm d
    echo $?
    2041 girt-show :d 
    cat d

    # test force option
    2041 girt-rm --force a 
    echo $?
    2041 girt-rm --force b 
    echo $?
    2041 girt-rm --force c
    echo $?
    2041 girt-rm --force d
    echo $?
    2041 girt-show :a
    2041 girt-show :b
    2041 girt-show :c
    2041 girt-show :d
    cat a
    cat b
    cat c
    cat d

    # test cached option
    # When the file content differ in cwd, latest commit, index
    echo "hello" > a 
    2041 girt-add a 
    2041 girt-commit -m 'asf'
    echo "world" >> a 
    2041 girt-add a 
    echo "HD plz" > a 
    2041 girt-rm --cached a 
    echo $?
    2041 girt-show :a
    cat a
    # cwd and index vs latest commit
    echo "yo" > b
    2041 girt-add b 
    2041 girt-commit -m 'afsg'
    echo "marker" >> b 
    2041 girt-add b 
    2041 girt-rm --cached b 
    echo $?
    2041 girt-show :b
    cat b
    # cwd and latest commit vs index (only one to fail)
    echo "100%" > c 
    2041 girt-add c 
    2041 girt-commit -m 'asf'
    echo "for test scripts" > c 
    2041 girt-add c 
    echo "100%" > c 
    2041 girt-rm --cached c
    echo $?
    2041 girt-show :c
    cat c
    # index and latest commit vs cwd
    echo "I sleep" > d 
    2041 girt-add d 
    2041 girt-commit -m 'asf'
    echo "I woke" > d
    2041 girt-rm --cached d
    echo $?
    2041 girt-show :d 
    cat d

    # non existent files 
    2041 girt-rm e
    echo $?
    2041 girt-rm --cached e
    echo $?
    2041 girt-rm --force e
    echo $?

    # using both options
    echo "hello" > a 
    2041 girt-add a 
    2041 girt-commit -m 'asf'
    echo "world" >> a 
    2041 girt-add a 
    echo "HD plz" > a 
    2041 girt-rm --force --cached a 
    echo $?
    2041 girt-show :a 
    cat a

) >>"sol.txt" 2>>"sol.txt"
cd ..
NC='\033[0m' # No Color
diff -s "output.txt" "solution/sol.txt" >/dev/null 2>/dev/null
if [ $? -eq 0 ]
then
    GREEN='\033[0;32m';
    echo "Test girt-rm -${GREEN}PASSED${NC}"
else
    RED='\033[0;31m';
    echo "Test girt-rm -${RED}FAILED${NC}"
    echo "<<<<<< Your answer on the left <<<<<<<                          >>>>>> Solution on the right >>>>>>>>"
    diff -y "output.txt" "solution/sol.txt"
fi