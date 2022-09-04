#!/bin/sh
# setup python library for cje1
#	by saka@slis.tsukuba.ac.jp
#	$Id: setup.sh,v 1.2 2022/06/09 01:04:36 saka Exp saka $
#

modules='
    cje1gw
'

dst='/root/.ipython'

if [ ! -d ${dst} ]; then
    mkdir -p ${dst}
fi

for m in ${modules}; do
    cp -prf ${m} ${dst}
done

echo 'Python Library for cje1gw INSTALLED!'
