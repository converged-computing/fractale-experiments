#!/bin/bash
#
#FLUX: --job-name=87.2.7
#FLUX: --output=./%x.%j.out
#FLUX: --error=./%x.%j.err
#FLUX: --cwd=./
#FLUX: --nodes=1
#FLUX: --ntasks=48
#FLUX: --time-limit=29m50s


# NOTE: The %x and %j format specifiers are not supported in Flux; files will be overwritten.






module load spack/22.2.1
module load intel-oneapi-toolkit/2022.3.0
module load hdf5/1.8.22-intel21-impi
module list

echo "PWD: $PWD"

date
# 'srun' is replaced with 'flux run'
flux run -n 48 ./athena -i ../tst/megKH/athinputmeg.kh
date
