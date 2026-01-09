#!/bin/bash

# Read header names from the input file into a variable
header_names=$(cat met_unassigned.txt)

# Initialize variables
capturing=false

# Loop through the FASTA file
while IFS= read -r line; do
    if [[ $line =~ ^\> ]]; then
        # Check if the header is in the list of desired header names
        if grep -q -w "${line:1}" <<< "$header_names"; then
            capturing=true
            echo "$line" >> filtered_met.fasta
        else
            capturing=false
        fi
    elif [ "$capturing" = true ]; then
        echo "$line" >> filtered_met.fasta
    fi
done < /Users/ninayang/Documents/Git/OTZ-AR43-Metabarcoding/00_qiime2-outputs/18S/prdb-metazoa-ctd-rep-seqs.fasta

echo "Filtered FASTA file generated."
