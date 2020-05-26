#!/usr/bin/env bash

BASE=https://localhost

#OPT="--verbose --insecure"
OPT="-s --insecure"

date=$(date +%Y-%m-%d)

repl=$(curl $OPT \
  $BASE/v1/buckets/$date)

if grep -q buckets <<< $repl ; then
	IFS=',' read -ra buckets <<< $(echo $repl | cut -d\[ -f2 | cut -d\] -f1)
else
	echo "No token"
	exit 1
fi

for keydate in ${buckets[@]}
do
	batch=$(curl $OPT \
  		$BASE/v1/exposedjson/$keydate)
	echo $batch
done
