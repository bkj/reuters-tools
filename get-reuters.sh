#!/bin/bash

source credentials
wget -r --user $RUSER --password $RPASS --no-check-certificate https://ir.nist.gov/reuters/
find ir.nist.gov | grep -E "xz|gz" | xargs -I {} cp {} ./
rm -r ir.nist.gov

tar -xf rcv1.tar.xz
tar -xf rcv2.tar.xz

mkdir -p ./data/orig/
mv ./rcv1 ./data/orig/
mv ./RCV2_Multilingual_Corpus ./data/orig/rcv2

mkdir -p ./archives
mv *xz archives
mv *gz archives