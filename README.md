# Mesopelagic Biodiversity & Ecological Networks from the Northwest Atlantic

This respository includes the data and code to recreate analyses and figures from the manuscript "Eukaryotic biodiversity and ecological networks from the surface to the mesopelagic in the Northwest Atlantic Slope Water". 

The manuscript preprint is available on bioRxiv: doi: https://doi.org/10.1101/2025.05.12.653512.

## Abstract

The diversity and interactions among mesopelagic organisms are difficult to study and as a result, are insufficiently unaccounted for in food web and biogeochemical models. This knowledge gap hinders our ability to model and forecast ecosystem function and formulate effective policies for conservation and management in the face of growing interest in exploiting midwater living resources. We used multi-marker metabarcoding of environmental DNA (eDNA) samples collected from Northwest Atlantic Slope Water to resolve patterns of eukaryotic community composition spanning taxonomically across protists (microbial eukaryotes), invertebrates, and vertebrates and vertically from the ocean surface to the base of the mesopelagic zone. With statistical network analyses, we explored cross-kingdom associations including trophic interactions such as food web dynamics and evaluate network robustness to biodiversity loss. We found depth-specific communities of distinct protist, invertebrate, and vertebrate assemblages. Ecological networks for the epipelagic, upper mesopelagic, and lower mesopelagic suggest that protists are keystone taxa and important mediators of trophic interactions; they increase network complexity and contribute to network stability. We also identified metazoans including copepods, gelatinous taxa (cnidarians, tunicates), and mesopelagic fish as important components of network interactions. Our study demonstrates a holistic approach to generate insights on mesopelagic biodiversity and implications for ecosystem resilience that can inform future conservation and management efforts.

## Folders and Files

Code and relevant input/output files: 

00_qiime2-outputs: QIIME 2 was used to process raw sequencing data. This directory includes output files from 18S and 12S metabarcoding and relevant metadata files for downstream analysis, e.g. decontamination. 
01_decontam: This directory includes R markdown files (.Rmd) with code for removing contaminant sequences or ASVs for 18S (protist and invertebrates are processed separatelY) and 12S (for vertebrates).
02_phyloseq: This includes the decontaminated phyloseq files from the decontam step that are used for diversity analyses and other analyses. 
03_diversity: This includes code and select input files to conduct the diversity analyses presented in the manuscript including rarefaction, alpha diversity, and beta diversity. 
04_network-analysis: This includes code and select input files for setting up inputs for network analysis using SPIEC-EASI (AR43_alleuk_setup_spieceasi_pub_final.Rmd) and code for evaluating the networks based on taxa (AR43_alleuk_spieceasi_overview_pub_final.Rmd) and positive/negative interactions (AR43_alleuk_spieceasi_interactions_pub_final.Rmd). 
05_ctd: This includes input files and code for processing ctd data and generating a sampling map with ctd profiles for where samples were collected.
