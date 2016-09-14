#!/bin/bash

mkdir -p sampled

N=100000
EN_OUT=sampled/reuters-data-100k.en.txt
DE_OUT=sampled/reuters-data-100k.de.txt

# --
# English

find rcv1/ | grep xml | gshuf | head -n $N |\
    parallel -P 10 --pipe -N 1000 "python parse-reuters.py" > $EN_OUT

cat $EN_OUT | awk -F '\t' '{print $3}' | tr '[:upper:]' '[:lower:]' | ./tools/tokenizer.perl en > tmp
paste -d '\t' $EN_OUT tmp | awk -F '\t' '{OFS="\t"; print "__label__"$2,$4}' > tmp2
rm tmp && mv tmp2 $EN_OUT

# --
# German

find rcv2/german | grep xml | gshuf | head -n $N |\
    parallel -P 10 --pipe -N 1000 "python parse-reuters.py" > $DE_OUT

cat $DE_OUT | awk -F '\t' '{print $3}' | tr '[:upper:]' '[:lower:]' | ./tools/tokenizer.perl de > tmp
paste -d '\t' $DE_OUT tmp | awk -F '\t' '{OFS="\t"; print "__label__"$2,$4}' > tmp2
rm tmp && mv tmp2 $DE_OUT