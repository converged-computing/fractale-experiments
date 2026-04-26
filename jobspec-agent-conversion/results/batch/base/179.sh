#!/bin/bash
# Submission script for Nic5
#FLUX: --time-limit=20d1h
#
#FLUX: --ntasks=1
#FLUX: --cores-per-task=20
#FLUX: --queue=bio

# The --mem-per-cpu=7500 (150GB total) parameter from slurm has no direct equivalent in flux-submit.
# The job may fail due to insufficient memory.


export OMP_NUM_THREADS=20
export MKL_NUM_THREADS=20

module --ignore-cache load Nextflow/21.08.0
nextflow run Braker.nf --genome=<genome.fna> --prot=<BrakerDB> --SRA=none --brakermode=<mode> --cpu=20 --currentpath=<PWD>
