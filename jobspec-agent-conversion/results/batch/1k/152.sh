#!/bin/bash
#FLUX: --nodes=1
#FLUX: --ntasks=32
#FLUX: --time-limit=2h
#FLUX: --output=mixcr_%a.out

# NOTE: The %a format specifier is not supported in Flux; files will be overwritten.


module load java
output=bcr/output
mkdir $output

# NOTE: This script is a job array. The SLURM_ARRAY_TASK_ID variable has been
# replaced with FLUX_JOB_CC. You must submit this job with 'flux submit --cc=1-21 ...'
i=$(ls mapped/*.bam| awk -v ArrayTaskID=$FLUX_JOB_CC 'FNR == ArrayTaskID {print}')
echo $i
f=`echo $i | awk -F"Aligned.sortedByCoord.out.bam" '{print $1}'`    

#cpu=19000
#run-trust4 -t 40 -f bcrtcr.fa --ref bcr/IMGT+C.fa -1 trimmed/A1.R1.fq.gz -2 trimmed/A2.R2.fq.gz -o $output
run-trust4 -t 40 -f bcr/bcrtcr.fa --ref bcr/IMGT+C.fa -b $i -o $output/$(basename $f)
