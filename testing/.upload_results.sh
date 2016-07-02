#!/bin/bash

# Don't call this script yourself, this is for Travis CI!

serverIP="198.23.128.60"

rawurlencode() {
  local string="${1}"
  local strlen=${#string}
  local encoded=""
  local pos c o

  for (( pos=0 ; pos<strlen ; pos++ )); do
     c=${string:$pos:1}
     case "$c" in
        [-_.~a-zA-Z0-9] ) o="${c}" ;;
        * )               printf -v o '%%%02x' "'$c"
     esac
     encoded+="${o}"
  done
  echo "${encoded}"    # You can either set a return variable (FASTER) 
  REPLY="${encoded}"   #+or echo the result (EASIER)... or both... :p
}

cd "$(dirname "$0")"/..

exitCode=0

name="Donald Pinckney" # TODO: Compute this from GIT
name=$(rawurlencode "$name")
bodyData="name=$name"
for problemDir in testing/*/
do
    problemDir=${problemDir%*/}
    problem=${problemDir##*/}
    resultsFile=$problemDir/results
    while IFS='' read -r line || [[ -n "$line" ]]; do
        testNum=$(echo "$line" | cut -d',' -f1)
        testNum=$(rawurlencode "$testNum")
        testCode=$(echo "$line" | cut -d',' -f2)
        testCode=$(rawurlencode "$testCode")
        testTime=$(echo "$line" | cut -d',' -f3)
        testTime=$(rawurlencode "$testTime")
        
        probTestKey="$problem,$testNum"
        probTestCodeKey=$(rawurlencode "$probTestKey-code")
        probTestTimeKey=$(rawurlencode "$probTestKey-time")
        bodyData="$bodyData&$probTestCodeKey=$testCode&$probTestTimeKey=$testTime"
    done < $resultsFile
done

wget --quiet --method POST --header 'content-type: application/x-www-form-urlencoded' --body-data "$bodyData" --output-document - http://$serverIP/

