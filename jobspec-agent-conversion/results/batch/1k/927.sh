#!/bin/bash

# Copy/paste this job script into a text file and submit with the command:
#    sbatch thefilename
# job standard output will go to the file slurm-%j.out (where %j is the job ID)

#FLUX: --time-limit=9d
#FLUX: --nodes=1
#FLUX: --tasks-per-node=16
#FLUX: --job-name="phyluce_trinity_ac"

# The --mem=50G directive has no direct analog in the provided flux submit options.
# This may impact job scheduling and resource allocation.
# The --mail directives were ignored as per instructions.

# LOAD MODULES, INSERT CODE, AND RUN YOUR PROGRAMS HERE
source activate phyluce162
​
module unuse /opt/rit/spack-modules/lmod/linux-rhel7-x86_64/Core
module use /opt/rit/modules
​
module load java/1.7.0_55
module load bowtie/1.1.2
​
​
phyluce_assembly_assemblo_trinity \
    --conf /ptmp/kevinq/assembly_conf/assembly_Feb2020_ac.conf \
    --output /ptmp/kevinq/trinity-assemblies \
    --log /ptmp/kevinq/logs \
    --clean \
    --cores 16
