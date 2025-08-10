#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

pushd "$SCRIPT_DIR/src/c" > /dev/null 2>&1
make ctest
popd > /dev/null 2>&1

sbt "testOnly ctest.HexTest"
