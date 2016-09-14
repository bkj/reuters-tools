#!/bin/bash
source credentials
wget -r --user $RUSER --password $RPASS --no-check-certificate https://ir.nist.gov/reuters/
find ir.nist.gov | grep -E "xz|gz" | xargs -I {} cp {} ./
rm -r ir.nistgov
