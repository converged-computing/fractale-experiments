#!/bin/bash 
#FLUX: --time-limit=1d15m
#FLUX: --ntasks=1
#FLUX: --cores-per-task=2



#echo "Using R:"
module load r/3.4.0

module load java/1.8.0_121

#echo "Starting  nextflow at `date`."
nextflow run  DSMC_taxa15.nf -resume
#echo "Finished nextflow  at `date`."

