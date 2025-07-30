#!/usr/bin/bash

REGCOUNT=3
TEMPCOUNT=2

addr=0

for (( i=1; i<=$REGCOUNT; i++ ))
do
    echo "    r${i}l = ${addr}"
    addr=$(($addr+1))
    echo "    r${i}h = ${addr}"
    addr=$(($addr+1))
done

for (( i=1; i<=$TEMPCOUNT; i++ ))
do
    echo "    t${i}l = ${addr}"
    addr=$(($addr+1))
    echo "    t${i}h = ${addr}"
    addr=$(($addr+1))
done
