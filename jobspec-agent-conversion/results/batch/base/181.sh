#!/bin/bash
#FLUX: --cores=8
#FLUX: --time-limit=12h
#FLUX: --queue=short
#FLUX: --job-name=rnaseq
#FLUX: --ntasks=1

# The --mem=64G parameter from slurm has no direct equivalent in flux-submit.
# The job may be scheduled on a node without enough memory.


module load gcc/6.2.0
module load python/3.7.4
module load perl/5.30.0
module load R/3.6.1

export PATH=/n/groups/zhanglab/meng/tools/java/bin:/n/groups/zhanglab/meng/tools/samtools:/n/groups/zhanglab/meng/tools/STAR:/n/groups/zhanglab/meng/tools/RSEM:/n/groups/zhanglab/meng/tools/fastqc:/n/groups/zhanglab/meng/tools/ucscTools:$PATH
export LD_LIBRARY_PATH=/n/groups/zhanglab/meng/tools/java/lib:$LD_LIBRARY_PATH


snakemake -j 8 -p
