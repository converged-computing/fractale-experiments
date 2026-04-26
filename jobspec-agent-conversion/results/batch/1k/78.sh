#!/bin/bash -l
#
# CP2K on Piz Daint
#FLUX: --job-name=df
#FLUX: --time-limit=1d
#FLUX: --nodes=1
#FLUX: --tasks-per-node=12
#FLUX: --ntasks=12
#FLUX: --cores-per-task=1



#========================================
# load modules and run simulation
module load daint-gpu

export CRAY_CUDA_MPS=1
export OMP_NUM_THREADS=1
ulimit -s unlimited

# 'srun' is replaced with 'flux run'
flux run -n 12 lmp_df < in.df &> lmplog &

wait

for a  in `seq 1 12`; do
 nline=$(echo "($a-1)*32009*8334+1" | bc); echo $nline; 
tail -n +$nline df.lammpstrj | head -n 266763010 > df.lammpstrj-part-$a &
wait
done

wait

# NOTE: `sbatch` is a Slurm command and will not work here.
# You will need to submit '../analyze.run' as a separate Flux job.
# sbatch ../analyze.run

sleep 1
