#!/usr/bin/env bash

BASE=https://localhost

#OPT="--verbose --insecure"
OPT="-s --insecure"

date=$(date +%Y-%m-%d)

curl $OPT \
  $BASE/v2/gaen/exposed | file -
