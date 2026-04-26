#!/bin/bash
#FLUX: --job-name=my_job
#FLUX: --error=Job_name.err.%J
#FLUX: --output=Job_name.out.%J
#FLUX: --time-limit=3m
#FLUX: --ntasks=1
#FLUX: --cores-per-task=16
#FLUX: --exclusive

echo "This is Job $FLUX_JOB_ID"
module load gcc
##module load openmpi/gcc
cd /home/kurse/kurs1/ui31dymo/Lap1/SPP_Uebungen/source_parktikum_c
./main text1.txt text4.txt
