#!/usr/bin/env bash
git clone https://github.com/k8s-edu/Bkv2_sub_colosseum
cd Bkv2_sub_colosseum
find /root/_Book_k8sInfra -regex ".*\.\(sh\)" -exec chmod 700 {} \;
echo "ⓘ Colosseum sources at: ~/_Book_k8sInfra/ch6/6.6.3/Bkv2_sub_colosseum"
