#!/bin/sh

cd "$(dirname $0)"
program=../update-passwd

n=0; f=0
for t in test-*; do
    echo ">>>> RUNNING: $t"
    mkdir -p testrun
    rm -rf testrun/*
    cp -f "$t"/* testrun/
    opts=""
    if test -f "$t/opts"; then
	opts=$(cat "$t/opts")
    fi
    "$program" -P testrun/passwd -p testrun/passwd.master -G testrun/group -g testrun/group.master -S testrun/shadow -L $opts "$@"
    failed=0
    diff -u testrun/passwd.expected testrun/passwd || failed=1
    diff -u testrun/group.expected testrun/group || failed=1
    diff -u testrun/shadow.expected testrun/shadow || failed=1
    test "$failed" != 0 && f=$(( $f + 1 ))
    n=$(( $n + 1 ))
done

if test "$f" = 0; then
    echo "SUCCESS ($n tests)".
    exit 0
else
    echo "$f of $n tests FAILED."
    exit 1
fi

