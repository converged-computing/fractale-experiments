#!/bin/sh
#FLUX: --job-name=prism
#FLUX: --queue=exclusive
#FLUX: --bank=etc
#FLUX: --nodes=1
#FLUX: --cores=68
#FLUX: --ntasks=24
#FLUX: --cores-per-task=1
#FLUX: --time-limit=4h

# The PBS -V directive is default behavior in Flux.
# The PBS email notification directives (-m, -M) have no direct Flux analog.
# The PBS -W sandbox=PRIVATE directive has no direct Flux analog.

# The script will start in the submission directory by default.
module purge
module load craype-x86-skylake gcc/7.2.0 openmpi/3.1.0
module load forge/18.1.2
module load cmake/3.17.4
module load python/3.7
module load tensorflow/1.12.0

python test2.py 1>stdout 2>stderr
