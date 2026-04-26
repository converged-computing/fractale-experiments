#! /bin/sh
#FLUX: --nodes=2
#FLUX: --tasks-per-node=2
#FLUX: --ntasks=4
#FLUX: --time-limit=5m


# cd $PBS_O_WORKDIR # This is the default behavior in Flux

. /etc/profile.d/modules.sh
module purge
module load nvidia nvmpi

mkdir -p sim_run
cd sim_run

nprocs=4
# 'mpirun' is replaced with 'flux run'. MCA flags are not directly translatable.
flux run -n $nprocs ../run 4096 4096 $nprocs 2000 50
