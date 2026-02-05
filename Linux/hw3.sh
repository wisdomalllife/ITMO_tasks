#!/bin/bash


#input="BRCA_mutations.tsv"
#input="test.txt"
#output="result2.txt"
hell="help.txt" # an output file that will store intermediate results
data="data.txt" # a temporary file used to hold extracted data from the tar archive
tar -tf TCGA.tar.gz | while read file; do
	tar -xOf TCGA.tar.gz "$file" > $data
	#Deletes the first line (header) from, Selects specific columns, Counts unique lines and outputs their frequency along with the line itself.
	sed '1d' $data | cut -f1,5-7,11,13 | awk '{ a[$0]++ } END{ for(x in a) print a[x]"\t", x }' > $hell
	var1=$(sed '1d' $data| wc -l) # the number of lines in data.txt after removing the header (total records)
	var2=$(sed '1d' $data| cut -f 16 | sort -u | wc -l) #  Extracts the 16th column, sorts it uniquely, and counts unique values 
	var3=$(echo "scale=0; $var1 / $var2" | bc) # the ratio of total records (var1) to unique identifiers (var2) using bc for basic arithmetic
	echo $var3
# extracts the base name of the current file (removing path and extension), which is assumed to follow a naming convention where it ends with _mutations.tsv
	name=$(basename "$file" | sed 's/\(.*\)_mutations\.tsv$/\1/')
	echo $name
	output="$name.txt"
# The combined output is then modified by replacing the first line with a custom header
	paste <(cut -f3-7 $hell | sed 's/\t/'_'/g') <(cut -f2 $hell) <(cut -f1 $hell) | sed "1c\ID\tgen_$name\trec_$name\_$var3" > $output
	done
