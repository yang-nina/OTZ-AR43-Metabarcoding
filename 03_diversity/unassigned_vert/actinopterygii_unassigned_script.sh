#!/bin/bash

# Read header names from the input file into a variable
header_names=$(cat actinopterygii_unassigned.txt)

# Initialize variables
capturing=false

# Loop through the FASTA file
while IFS= read -r line; do
    if [[ $line =~ ^\> ]]; then
        # Check if the header is in the list of desired header names
        if grep -q -w "${line:1}" <<< "$header_names"; then
            capturing=true
            echo "$line" >> filtered_unassigned_actinopterygii.fasta
        else
            capturing=false
        fi
    elif [ "$capturing" = true ]; then
        echo "$line" >> filtered_unassigned_actinopterygii.fasta
    fi
done < /Users/ninayang/Documents/Git/OTZ-AR43-Metabarcoding/00_qiime2-outputs/12S/12s-vert-ctd-rep-seqs.fasta
echo "Filtered FASTA file generated."
