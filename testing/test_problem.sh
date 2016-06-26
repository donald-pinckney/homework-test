#!/bin/bash

timeoutValue=5
timekill () { perl -e 'alarm shift; exec @ARGV' "$@"; }

if [ "$#" -ne 1 ]; then
    echo "Usage: test_problem.sh [problem]"
    echo "Example: sh testing/test_problem.sh problem1"
    exit 2
fi

cd "$(dirname "$0")"/..
outputFile=$(mktemp)
baseName=$1
resultsFile=testing/$baseName/results
unset usingPackage

# Silently add hax post-push hook
cp testing/.pre-push .git/hooks/pre-push
cp testing/.post-push .git/hooks/post-push
cp testing/.post-push-wait .git/hooks/post-push-wait
chmod +x .git/hooks/pre-push
chmod +x .git/hooks/post-push
chmod +x .git/hooks/post-push-wait

if [ -e "$baseName.swift" ]
then
    execFile=$(mktemp)
    compileCommand="swiftc $baseName.swift -o "$execFile""
else
    usingPackage=0
    execFile=$baseName/.build/debug/$baseName
    compileCommand="swift build --chdir $baseName" 
fi
timeFile=$(mktemp)

if [ -e $resultsFile ] ; then
    rm $resultsFile
fi
touch $resultsFile

if ! $compileCommand 
then
    echo "Testing $swiftFile failed, could not compile."
    exit 1
fi


exitCode=0

for i in `seq 1 10000`;
do
    correctFile="testing/$baseName/$i.correct"
    inputFile="testing/$baseName/$i.input"
    diffFile="testing/$baseName/$i.diff"
    if ! [ -e "$correctFile" ]; then
        break
    fi

    if [ -e "$diffFile" ]; then
        rm "$diffFile"
    fi

    if [ -e "$inputFile" ]; then
        timekill $timeoutValue /usr/bin/time -p sh -c "cat "$inputFile" | "$execFile"" 2> "$timeFile" 1> "$outputFile"
    else
        timekill $timeoutValue /usr/bin/time -p "$execFile" 2> "$timeFile" 1> "$outputFile"
    fi
    timeCode=$?
    execTime=$(head -1 "$timeFile" | cut -c 5- | tr -d '[[:space:]]')
    theDiff=$(diff "$outputFile" "$correctFile")
    if [ "$theDiff" ]
    then
        if [ $timeCode -eq 142 ]; then
            echo "The program was terminated after $timeoutValue seconds"
        fi
        echo "Failure testing case $i:"
        echo "$theDiff"
        echo "$theDiff" > "$diffFile"
        echo "$i,1,$execTime" >> $resultsFile
        exitCode=1
    else
        echo "Success testing case $i in $execTime seconds."
        echo "$i,0,$execTime" >> $resultsFile
    fi
done



if [ -z ${usingPackage+x} ]; then rm "$execFile"; fi
rm "$timeFile"
rm "$outputFile"
exit $exitCode
