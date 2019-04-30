#!/bin/bash
NEW1=`cat /dev/urandom | tr -cd '!#$&%@()[]' | head -c 2`
NEW2=`cat /dev/urandom | tr -cd 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ123456789' | head -c 14`
OUTPUT=$NEW1$NEW2
echo $OUTPUT

