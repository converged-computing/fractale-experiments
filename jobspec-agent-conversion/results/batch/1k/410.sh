#!/bin/bash
#FLUX: --cc=1-100
#FLUX: --ntasks=5
#FLUX: --job-name=reABC
#FLUX: --output=logs/ABC/sims/ro.o
#FLUX: --error=logs/ABC/sims/ro.e
#FLUX: --time-limit=3h30m


module purge
module load julia/1.8.2

export FLUX_NODEFILE=$(flux resource list -o hosts)
cp $FLUX_NODEFILE logs/ABC/nodefiles/nodes_${FLUX_JOB_CC}
julia --machine-file $FLUX_NODEFILE --sysimage src/PkgCompile/ABCPrecompiledSysimage.so ~/SpatialRust/scripts/ABC/sims/re-runABC.jl 5 $FLUX_JOB_CC $FLUX_NTASKS 2000 quants3 14
# ARGS: params file, slurm job array id, # cores, # sims per core, quants dirname, hours


