#!/bin/bash

echo hello
final_file="final_file.txt"
output_file="result.txt"
file1="50_irnt.gwas.imputed_v3.both_sexes_hail.tsv.bgz"
file2="50_irnt.gwas.imputed_v3.both_sexes_rsids.tsv.bgz"

# intermediate output files
snp="rsID.txt"
zscor="zscor.txt"
s_size="s_size.txt"
pval="pval.txt"
altal="altal.txt"
refal="refal.txt"

#Joining Files
join -1 1 -2 1 -t $'\t' <(zcat $file1 | sed 's/\t/''/1' | sort -t $'\t' -k 1)  <(zcat $file2 | sed 's/\t/''/1' | sort -t $'\t' -k 1) | grep 'false' | sed 's/\[/\t\[/1' > $output_file

#sed 's/\t/''/1': Replaces the first tab character with an empty string (effectively removing it).
#sort -t $'\t' -k 1: Sorts the output by the first column, treating tabs as field separators.
#join -1 1 -2 1 -t $'\t': Joins the two sorted outputs based on the first column (the SNP IDs). The -1 and -2 options specify that we are joining on the first field of both inputs.
#grep 'false': exclude all low_confidence_variant.
#sed 's/[/\t[/1': Modifies the output by replacing the first occurrence of [ with a tab followed by [.

cut -f 12 $output_file > $snp # rsID.txt

# checks if the second field is a number, and calculates a ratio of the first field to the second if it is not zero.
cut -f 8,9 $output_file | awk '$2 ~ /^[0-9]+[\.]?[0-9]+/{if ($2!=0) {$3=$1/$2}}1' > $zscor

# the first field, splits it by : to get two values, checks if the second value is numeric, and calculates their difference.  
cut -f 1 $output_file | awk 'BEGIN{FS=":"} $2 ~ /^[0-9]+[\.]?[0-9]+/ {$3=$2-$1}1' > $s_size

cut -f 11 $output_file > $pval

#Extract Alternative Alleles and Reference Alleles
# sed 's/[^"]*"\([^"]*\).*/\1/': select a word in quotation marks
cut -f 2 $output_file |cut -d$',' -f2 | sed 's/[^"]*"\([^"]*\).*/\1/' > $altal
cut -f 2 $output_file | sed 's/[^"]*"\([^"]*\).*/\1/' > $refal

#Combine multiple files (including SNP IDs, alternative alleles, reference alleles, sample sizes, p-values, and z-scores) into a single tab-separated output.
#Replace the first line of the combined output with a custom header.
paste $snp $altal $refal <(cat $s_size | cut -d$' ' -f3) $pval <(cat $zscor | cut -d$' ' -f3) | sed '1c\SNP\tA1\tA2\tN\tP\tZ' > $final_file


#sed '1h;1d;$!H;$!d;G' infile - last line to header
#sed '1c\SNP\tAlternative allele\tReference allele\tP-value\tZ-score' train.txt - change title
# ID=$(sed -n '1p' result.txt| tr ' ' '\n' | grep -nE 'alleles|beta|se|pval|rsid' | sed 's/:.*//g' | tr '\n' ',') && cut -d$' ' -f${ID%?} result.txt выбрать столбцы


