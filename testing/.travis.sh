#!/bin/bash

# Don't call this script yourself, this is for Travis CI!

if [ "${TRAVIS_PULL_REQUEST}" = "false" ]; then
    exit 0
elif [ -z ${TRAVIS_PULL_REQUEST+x} ]; then
    exit 0
fi

cd "$(dirname "$0")"/..

testing/test_all.sh
exitCode=$?
testing/.upload_results.sh

exit $exitCode
