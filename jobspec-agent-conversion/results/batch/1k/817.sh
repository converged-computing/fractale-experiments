#!/bin/bash
#FLUX: --job-name=pod-ompi2-ubuntu16
#FLUX: --nodes=2
#FLUX: --tasks-per-node=28
#FLUX: --ntasks=56
#FLUX: --time-limit=5m

# NOTE: The -j oe (join output/error) option is not supported.
# Default output and error files will be created.

echo "Job ID: $FLUX_JOB_ID"
echo "Queue:  B30" # Static value from original script
NPROCS=$(flux resource list | wc -l)
echo "Cores:  $NPROCS"
echo "Nodes:  $(flux resource list | sort -u | tr '\n' ' ')"

# cd $PBS_O_WORKDIR # This is the default behavior in Flux
module load singularity/2.4.2
module load openmpi/2.0.1/gcc.6.2.0

SINGIMG=pod-ompi2-ubuntu16.img
# NOTE: MPIARGS are not directly translatable to 'flux run'.
# They may need to be set as environment variables if required.
# MPIARGS='-mca btl_tcp_if_include ib0 -mca btl tcp,sm,self'

# 'mpirun' is replaced with 'flux run'
flux run -n 56 singularity exec $SINGIMG /usr/bin/mpi_ring
exit $?

# vim: syntax=sh:ts=4:sw=4:expandtab
