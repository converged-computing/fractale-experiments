#!/bin/sh -l
#FLUX: --output=job.out
#FLUX: --ntasks-per-node=128
#FLUX: --ntasks=128
#FLUX: --time-limit=2d30m


module purge
module load gcc
module load openmpi
conda activate ost

export OMP_NUM_THREADS=1

CODE=$FLUX_JOB_NAME
NODE=$FLUX_JOB_NNODES
PER=$FLUX_TASKS_PER_NODE
LMPCMD="'flux run -n 384 --cpus-per-task=1 ~/Github/lammps/src/lmp_mpi -in cycle.in > cycle.out'"

CMD="python demo_mt.py -d dataset/mech.db -c ${CODE} -n ${NODE} -p ${PER} -l ${LMPCMD} > log_${CODE}"
echo $CMD
eval $CMD

#sbatch -J COUMAR13 -N 1 myrun-uncc


