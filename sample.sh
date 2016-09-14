#!/bin/bash

# EN_OUT=sampled/reuters-data.en.txt
# DE_OUT=sampled/reuters-data.de.txt
# N = 15000

EN_OUT=sampled/reuters-data-100k.en.txt
DE_OUT=sampled/reuters-data-100k.de.txt
N=100000

# --
# Sample
mkdir -p sampled

find rcv1/ | grep xml | shuf |\
    parallel -P 10 --pipe -N 1000 "python parse-reuters.py" |\
    head -n $N > $EN_OUT

find rcv2/german | grep xml | shuf |\
    parallel -P 10 --pipe -N 1000 "python parse-reuters.py" |\
    head -n $N > $DE_OUT

# --
# Clean English
cat $EN_OUT |\
    awk -F '\t' '{print $3}' |\
     tr '[:upper:]' '[:lower:]' |\
     ../europarl/tools/tokenizer.perl en > tmp

paste -d '\t' $EN_OUT tmp |\
    awk -F '\t' '{OFS="\t"; print $1,$2,$4}' > tmp2

rm tmp
mv tmp2 $EN_OUT


# --
# Clean german
cat $DE_OUT |\
    awk -F '\t' '{print $3}' |\
     tr '[:upper:]' '[:lower:]' |\
     ../europarl/tools/tokenizer.perl de > tmp

paste -d '\t' $DE_OUT tmp |\
    awk -F '\t' '{OFS="\t"; print $1,$2,$4}' > tmp2

rm tmp
mv tmp2 $DE_OUT

