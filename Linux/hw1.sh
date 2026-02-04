#!/bin/bash

output_file="example.txt"
echo -e "File name \tNumber of variants \tNumber of samples" > $output_file

tar -tf 1000G.tar.gz | while read file; do 
		variants=$(tar -xOf 1000G.tar.gz "$file"| zcat | grep -v "#" | wc -l)
		samples=$(tar -xOf 1000G.tar.gz "$file" | zcat | grep "#CHROM" | awk '{print NF-9}')
		echo -e "$file\t$variants\t$samples" >> $output_file
	done

