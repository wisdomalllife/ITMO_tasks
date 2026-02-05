#!/bin/bash

echo hello
#file1="BLCA.txt"
output="output.txt"

#/home/victoria/homework2/result/samples/BRCA.txt
for file in /home/victoria/homework2/result/samples/*.txt; do 
	join -1 1 -2 1 -a1 -a2 -e '0' -o auto -t $'\t' $output  <(cat $file | sort -t $'\t' -k 1) > tmp; mv tmp $output 
	done

#the join should use the first column from the first input, the first column from the second input
# Include all lines from the first file and the second file, even if there is no match
# Replace missing fields with '0', automatically determine the output format, the input files are tab-separated
# sort the current $file by its first column before joining it with $output
#The output of the join command is redirected to a temporary file named tmp.
#mv tmp $output: This renames tmp back to output.txt, effectively updating it with the joined results after each iteration.
