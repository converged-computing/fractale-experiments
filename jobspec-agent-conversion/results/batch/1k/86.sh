#!/bin/sh
# The -V (export all environment variables) is the default behavior in Flux.
#FLUX: --job-name=prism
# The -q exclusive (queue) and -A etc (account) directives are ignored.
# The -l select=1:ncpus=68:mpiprocs=24:ompthreads=1 directive is complex.
# Translating to 1 node, 24 tasks (from mpiprocs), and letting Flux manage core allocation.
# A total of 68 cpus were requested, which is not a multiple of 24, so this is ambiguous.
# We will request 24 tasks and let Flux handle placement on the node.
#FLUX: --nodes=1
#FLUX: --ntasks=24
#FLUX: --time-limit=4h
# The -m abe and -M ... directives (mail) are ignored.
# The -W sandbox=PRIVATE directive has no direct flux analog and is omitted.

# The PBS_O_WORKDIR variable is replaced by FLUX_JOB_CWD
cd $FLUX_JOB_CWD

module purge
module load craype-x86-skylake gcc/7.2.0 openmpi/3.1.0
module load forge/18.1.2
module load cmake/3.17.4
module load python/3.7
module load tensorflow/1.12.0

python test2.py 1>stdout 2>stderr
