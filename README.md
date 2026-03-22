# DGR Analysis Pipeline

A bioinformatic workflow for identifying and characterizing diversity-generating retroelements (DGRs) in human gut microbial genomes.

## Overview
This repository contains my custom scripts, workflow notes, and environment files for DGR discovery and downstream analysis.

## Main components
- RT anchoring
- TR/VR calling
- A-to-N signature filtering
- Primary TR/VR selection
- Remote target search
- VR peptide extraction and alignment
- Pfam-based context interpretation

## Tools used
- BLAST
- Prodigal
- MAFFT
- HMMER
- Pfam

## Note
This repository contains my own wrapper scripts and workflow documentation. External tools such as MetaCSST are not redistributed here.

## Repository contents
- `scripts/` custom analysis scripts
- `env/` exported conda environments
- `docs/` workflow notes
- `results_example/` selected small example outputs

## Note
This repository contains my own workflow scripts and documentation, not redistributed third-party software.
