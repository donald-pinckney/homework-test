#!/bin/bash

cd "$(dirname "$0")"/..

for problemDir in testing/*/
do
    problemDir=${problemDir%*/}
    problem=${problemDir##*/}
    echo "Testing $problem"
    bash testing/test_problem.sh $problem
done
