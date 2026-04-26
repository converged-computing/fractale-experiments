#!/bin/bash

#FLUX: --job-name=liftover
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: --output=job_{id}.out

# NOTE: The original script was intended to be run as a job array.
# A placeholder has been added below. Please adjust the range as needed.
#FLUX: --cc=1-22

# define input and output directories
input_dir=/ref/mblab/data/llfs/geno_chip
output_dir=lifted_over_vcf
hg19_to_hg38_chain=/ref/mblab/data/human/hg19ToHg38.over.chain.gz
reference=/ref/mblab/data/human/GRCh38/GRCh38.primary_assembly.genome.fa

mkdir $output_dir

# define file names for input and output files
input_file=${input_dir}/llfs_gwas.chr${FLUX_JOB_CC}.vcf.gz
output_file=${output_dir}/llfs_gwas.chr${FLUX_JOB_CC}_hg38.vcf
reject_file=${output_dir}/llfs_gwas.chr${FLUX_JOB_CC}_hg38_rejected.vcf

eval $(spack load --sh picard)

# run Picard LiftoverVcf tool on input file
picard LiftoverVcf \
     I=${input_file} \
     O=${output_file} \
     CHAIN=${hg19_to_hg38_chain} \
     REJECT=${reject_file} \
     R=$reference
