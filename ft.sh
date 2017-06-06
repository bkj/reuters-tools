#!/bin/bash

TARGET_LANG_SHORT="de"

# --
# Train/test split

N=15000

cat ./data/en/clean.txt | shuf | head -n $N | cut -d$'\t' -f2,3 | sed 's/^/__label__/g' > ./data/en/ft
head -n 10000 ./data/en/ft > ./data/en/train.ft
tail -n 5000 ./data/en/ft | head -n 4000 > ./data/en/test.ft
tail -n 5000 ./data/en/ft | tail -n 1000 > ./data/en/valid.ft

cat ./data/$TARGET_LANG_SHORT/clean.txt | shuf | head -n $N | cut -d$'\t' -f2,3 | sed 's/^/__label__/g' > ./data/$TARGET_LANG_SHORT/ft
head -n 10000 ./data/$TARGET_LANG_SHORT/ft > ./data/$TARGET_LANG_SHORT/train.ft
tail -n 5000 ./data/$TARGET_LANG_SHORT/ft | head -n 4000 > ./data/$TARGET_LANG_SHORT/test.ft
tail -n 5000 ./data/$TARGET_LANG_SHORT/ft | tail -n 1000 > ./data/$TARGET_LANG_SHORT/valid.ft

# --
# Modeling

# en
fasttext supervised \
    -input ./data/en/train.ft \
    -output ./data/en/m \
    -validation ./data/en/valid.ft \
    -saveVectors 0 \
    -saveLabelVectors 0 \
    -loss softmax \
    -minCount 20 \
    -thread 1 \
    -epoch 20

fasttext test ./data/en/m.bin ./data/en/valid.ft
fasttext test ./data/en/m.bin ./data/en/test.ft
# 0.96

# de
fasttext supervised \
    -input ./data/de/train.ft \
    -output ./data/de/m \
    -validation ./data/de/valid.ft \
    -saveVectors 0 \
    -saveLabelVectors 0 \
    -loss softmax \
    -minCount 20 \
    -thread 1 \
    -epoch 20

fasttext test ./data/de/m.bin ./data/de/valid.ft
fasttext test ./data/de/m.bin ./data/de/test.ft
# 0.96