#!/bin/bash

cd "$(dirname "$0")"/..

exitCode=0

for problemDir in testing/*/
do
    problemDir=${problemDir%*/}
    problem=${problemDir##*/}
    echo "Testing $problem"
    if ! bash testing/test_problem.sh $problem; then
        exitCode=1
    fi
done

exit $exitCode
