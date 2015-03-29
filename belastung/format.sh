#!/bin/bash

touch summary
rm summary

for FILE in $(ls | grep '^test_' | sed -e's/\.txt//g')
do
    echo $FILE
    echo $FILE >> summary
    grep 'real' $FILE.txt | sed -e 's/[[:alpha:]]\+\t//g' | awk -F 'm' '{ split($2,s,"."); printf "%d.%s\n",$1*60+s[1],s[2] }' | sed -e 's/s//g' | tee $FILE.csv | Rscript -e 'print(summary(scan("stdin")));' >> summary
done
