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

if [ -e "$baseName.swift" ]
then
    execFile=$(mktemp)
    compileCommand="swiftc $baseName.swift -o "$execFile""
else
    usingPackage=0
    execFile=$baseName/.build/debug/$baseName
    swift build --chdir $baseName --clean
    compileCommand="swift build --chdir $baseName" 
fi
timeFile=$(mktemp)

if [ -e $resultsFile ] ; then
    rm $resultsFile
fi
touch $resultsFile

noComp=false
if ! $compileCommand 
then
    echo "Testing $swiftFile failed, could not compile."
    noComp=true
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

    echo "" > "$outputFile"

    if [ -e "$inputFile" ]; then
        timekill $timeoutValue /usr/bin/time -p sh -c "cat "$inputFile" | "$execFile"" 2> "$timeFile" 1> "$outputFile"
    else
        timekill $timeoutValue /usr/bin/time -p "$execFile" 2> "$timeFile" 1> "$outputFile"
    fi

    timeCode=$?
    didTimeout=false
    didRuntimeError=false
    if [ $timeCode -ge 2 ]; then
        didTimeout=true
    elif [ $timeCode -eq 1 ]; then
        didRuntimeError=true
    fi

    # TODO: Implement check for user programmer erroring / crashing.
    execTime=$(tail -3 "$timeFile" | head -1 | cut -c 5- | tr -d '[[:space:]]')
    theDiff=$(diff "$outputFile" "$correctFile")
    if [ "$noComp" = true ]; then
        echo "Failure testing $baseName case $i, since the program did not compile."
        echo "$i,3,0 seconds" >> $resultsFile
        exitCode=1
    elif [ "$didTimeout" = true ]; then
        echo "Failure testing $baseName case $i, since the program did not terminate within $timeoutValue seconds."
        echo "$theDiff"
        echo "$theDiff" > "$diffFile"
        echo "$i,2,$timeoutValue seconds" >> $resultsFile
        exitCode=1
        sleep 2
    elif [ "$didRuntimeError" = true ]; then
        echo "Failure testing $baseName case $i, since the program crashed while running."
        cat "$timeFile"
        echo "$i,4,$execTime seconds" >> $resultsFile
        exitCode=1
    elif [ "$theDiff" ]
    then
        echo "Failure testing $baseName case $i, since there was a difference in output:"
        echo "$theDiff"
        echo "$theDiff" > "$diffFile"
        echo "$i,1,$execTime seconds" >> $resultsFile
        exitCode=1
    else
        echo "Success testing $baseName case $i in $execTime seconds."
        echo "$i,0,$execTime seconds" >> $resultsFile
    fi
done



if [ -z ${usingPackage+x} ]; then rm "$execFile"; fi
rm "$timeFile"
rm "$outputFile"
exit $exitCode
