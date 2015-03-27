#!/bin/bash

touch summary
rm summary

for FILE in $(ls | grep '^test_' | sed -e's/\.txt//g')
do
    echo $FILE
    echo $FILE >> summary
    sed -e 's/[[:alpha:]]\+\t//g' $FILE.txt | awk -F 'm' '{ split($2,s,"."); printf "%d.%s\n",$1*60+s[1],s[2] }' | sed -e 's/0.$//g' | tr '\n' ';' | sed -e 's/\;\;/\n/g' -e 's/^\;//' -e 's/\;$/\n/' -e 's/s//g' | tee $FILE.csv | awk -F ';' '{ print $1 }' | Rscript -e 'print(summary(scan("stdin")));' >> summary
done
