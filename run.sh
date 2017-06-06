#!/bin/bash

# --
# Helpers

function clean {
    cat | cut -d$'\t' -f3 | tr '[:upper:]' '[:lower:]' | ./tools/tokenizer.perl -l $1
}
export -f clean

# --
# Params

TARGET_LANG="german"
TARGET_LANG_SHORT="de"
TARGET_OUT="./data/$TARGET_LANG_SHORT"

# --
# Run

mkdir -p ./data/en
mkdir -p $TARGET_OUT

# English
find ./data/orig/rcv1/ -type f | fgrep xml > ./data/en/filenames
cat ./data/en/filenames | parallel --pipe -N 1000 ./parse-reuters.py > ./data/en/parsed.txt
cat ./data/en/parsed.txt | parallel -k --pipe clean en |\
    paste -d'\t' ./data/en/parsed.txt - | cut -d$'\t' -f1,2,4 > ./data/en/clean.txt

# Target lang
find ./data/orig/rcv2/$TARGET_LANG -type f | fgrep xml > $TARGET_OUT/filenames
cat $TARGET_OUT/filenames | parallel --pipe -N 1000 ./parse-reuters.py > $TARGET_OUT/parsed.txt
cat $TARGET_OUT/parsed.txt | parallel -k --pipe clean $TARGET_LANG_SHORT |\ 
    paste -d'\t' $TARGET_OUT/parsed.txt - | cut -d$'\t' -f1,2,4 > $TARGET_OUT/clean.txt