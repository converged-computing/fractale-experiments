#!/bin/bash -l

#FLUX: --job-name=mpi
#FLUX: --nodes=2
#FLUX: --ntasks=2
#FLUX: --tasks-per-node=1
#FLUX: --time-limit=20m
#FLUX: --output=benchmark_pawsey.out

image="docker://pawsey/mpich-base:3.1.4_ubuntu18.04"
osu_dir="/usr/local/libexec/osu-micro-benchmarks/mpi"

# this configuration depends on the host
module load singularity


# see that SINGULARITYENV_LD_LIBRARY_PATH is defined (host MPI/interconnect libraries)
echo $SINGULARITYENV_LD_LIBRARY_PATH

# 1st test, with host MPI/interconnect libraries
flux run singularity exec $image \
  $osu_dir/pt2pt/osu_bw -m 1024:1048576


# unset SINGULARITYENV_LD_LIBRARY_PATH
unset SINGULARITYENV_LD_LIBRARY_PATH

# 2nd test, without host MPI/interconnect libraries
flux run singularity exec $image \
  $osu_dir/pt2pt/osu_bw -m 1024:1048576

