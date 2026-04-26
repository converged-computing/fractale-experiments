#!/bin/bash

#FLUX: --ntasks=1

source activate PopCOGenT
source /home/parevalo/apps/mugsy_trunk/mugsyenv.sh
snakemake --cluster-config cluster.yml --cluster "flux submit --queue={cluster.partition} --nodes={cluster.nodes} --ntasks={cluster.cores} --job-name={rulename}.{jobid}" --jobname {rulename}.{jobid} --jobs 250


