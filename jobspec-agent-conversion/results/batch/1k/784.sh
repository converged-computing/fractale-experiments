#!/bin/bash 
#FLUX: -J erpMpiTesting

p=$1
numabind=$2
module use /gpfs/u/software/erp-spack-install/lmod/linux-centos7-x86_64/Core/
module load gcc
ompi=/gpfs/u//software/erp-rhel7/openmpi/4.0.1/2/
export PATH=$PATH:$ompi/bin
osu=/gpfs/u/home/CCNI/CCNIsmth/barn-shared/CWS/osu-micro-benchmarks-5.6.1-erp-openmpi.4.0.1-verbs-noUcx-Pmi-install/
bin=$osu/libexec/osu-micro-benchmarks/mpi/

# NOTE: Flux's --setopt=cpu-affinity=per-task may be a partial equivalent to --bind-to core
binding="--setopt=cpu-affinity=per-task"
echo "processes $p"
NUM_NODES=$(flux resource list | wc -l)
echo "nodes $NUM_NODES"
echo "ppn $((p/NUM_NODES))"
echo "binding ${binding}"


set -x
export OMPI_MCA_btl_tcp_if_include="ib0"
export OMPI_MCA_btl_openib_allow_ib="1"

# 'mpirun' is replaced with 'flux run'
flux run ${binding} -n $p $bin/collective/osu_allreduce
set +x
