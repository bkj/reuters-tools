#!/bin/bash
source credentials
wget -r --user $RUSER --password $RPASS --no-check-certificate https://ir.nist.gov/reuters/
find ir.nist.gov | grep -E "xz|gz" | xargs -I {} cp {} ./
rm -r ir.nist.gov

tar -xzvf rcv1.tar.xz
tar -xzvf rcv2.tar.xz
mv RCV2_Multilingual_Corpus rcv2

mkdir -p archives
mv *xz archives
mv *gz archives