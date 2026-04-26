#!/bin/bash
#FLUX: --job-name=filter_VCF_for_snpEff
#FLUX: --output=./logs/filter_VCF_for_snpEff.log
#FLUX: --error=./logs/filter_VCF_for_snpEff.err
#FLUX: --ntasks=1
#FLUX: --cores-per-task=8
#FLUX: --nodes=1
#FLUX: --time-limit=5h

module load vcftools/0.1.16

VCFTOOLSIMG=/share/pkg/vcftools/0.1.16/vcftools-0.1.16.sif

for CHR in {9..28}; do

input_vcf=/project/uma_lisa_komoroske/Blair/WGR_for_genome/snpEff/DerCor/inputs/all_DerCor_SUPER_${CHR}.vcf
fileprefix=$CHR

######################################
### Filter VCF for use with snpEff ###
######################################

### 
singularity exec $VCFTOOLSIMG vcftools --vcf $input_vcf --min-meanDP 5 --max-meanDP 200 --recode --mac 1 --out ./snpEff/DerCor/inputs/SUPER_${fileprefix}

done
