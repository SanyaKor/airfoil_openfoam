#!/bin/bash


rm -r postProcessing/forcesCoeffs 2> /dev/null 

timestaps_amount=1000
i=50
while [ $i -le $timestaps_amount ]
do
  rm -rf $i
  i=$((i+50))
done