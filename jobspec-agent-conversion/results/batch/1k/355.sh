#!/bin/bash
#FLUX: --time-limit=1m
#FLUX: --nodes=2
#FLUX: --ntasks-per-node=1
#FLUX: --cores-per-task=1
#FLUX: --output=myJob.out
#FLUX: --error=myJob.err

module use /marconi_work/ExaF_prod_0/spack/opt/spack/linux-centos7-broadwell/gcc-7.3.0/openmpi-4.0.1-tsuqdoly7rjs3vy6dk5pugjj4so3cu26

module load openmpi-4.0.1-gcc-7.3.0-tsuqdol

flux mini run -n 2 hello
