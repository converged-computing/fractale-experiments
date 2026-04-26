#!/bin/bash 
#FLUX: --job-name=DoubNP
#FLUX: --nodes=12
#FLUX: --ntasks=1152
#FLUX: --time-limit=12h
#FLUX: --cores-per-task=2


echo $(date)
echo -e "================================================================================\n"

THREADS=2
# export SLURM_CPU_BIND=none # Not directly translatable
# export SLURM_CPUS_PER_TASK=$THREADS # This is now a job-level directive
export OMP_NUM_THREADS=$THREADS
export GMX_MAXCONSTRWARN=-1

module load intel/19.1.3
module load impi/2019.9
module load gromacs/2021.2-plumed

STYLE=npt

if [ -f $TPRFILE ]; then
     # 'srun' is replaced by 'flux run'
     flux run -n 1152 gmx_mpi mdrun -v -s $STYLE \
                        -o $STYLE \
                        -e $STYLE \
                        -x $STYLE \
                        -c $STYLE \
                        -cpo $STYLE \
                        -cpi $STYLE.cpt \
                        -ntomp $THREADS \
                        -dlb yes \
                        -pin on
fi
