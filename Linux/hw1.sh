#!/bin/bash

output_file="example.txt"
echo -e "File name \tNumber of variants \tNumber of samples" > $output_file
# a header line to the output file. The -e flag allows for interpretation of escape sequences(\t creates tab-separated columns in the output file).

tar -tf 1000G.tar.gz | while read file; do 										#  lists all the files contained in the 1000G.tar.gz archive
		variants=$(tar -xOf 1000G.tar.gz "$file"| zcat | grep -v "#" | wc -l)	# Extract the content of the current file, count the number of variants.
		samples=$(tar -xOf 1000G.tar.gz "$file" | zcat | grep "#CHROM" | awk '{print NF-9}') # Find the header line that contains sample names, count the number of fields (columns) in that line and subtract 9 (the first 9 fields usually represent metadata columns in VCF files), giving the number of sample columns.
		echo -e "$file\t$variants\t$samples" >> $output_file 					# file name, number of variants, and number of samples, separated by tabs
	done

#another possible option to calculate # of columns: convert a header line into 1 column: grep  "^#CHROM" | tr '\t' '\n'
