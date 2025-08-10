#!/usr/bin/env bash

sbt "testOnly fetch.HexTest"
sbt "testOnly decode.HexTest"
sbt "testOnly lw.HexTest"
sbt "testOnly sw.HexTest"
