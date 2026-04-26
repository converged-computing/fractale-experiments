#!/bin/bash -l

#FLUX: --ntasks=144
#FLUX: --time-limit=23h30m
#FLUX: --error=error.err
#FLUX: --job-name=perWetFin 


module load git
module load gcc/9.2.0
module load openmpi/4.0.3
module load boost
module load eigen/3.3.7
module load cmake
module load python/3.7.4
module load gnuplot
module load texlive

source /work/projects/special00005/B01/OpenFOAM-v2112/etc/bashrc

# 'srun' is replaced with 'flux run'
flux run -n 144 interFlow -parallel -fileHandler collated > log
flux run -n 144 foamToVTK -parallel > log.foamToVTK
