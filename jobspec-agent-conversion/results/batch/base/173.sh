#!/usr/bin/env sh
#FLUX: --job-name=rate_shift_type
#FLUX: --output=logs/rate_shift_type.log
#FLUX: --error=logs/rate_shift_type.err
#FLUX: --ntasks=1
#FLUX: --nodes=1
#FLUX: --cores-per-task=100
#FLUX: --queue=krypton

# The --mail-type and --mail-user parameters from slurm have no direct equivalent in flux-submit.
# The --mem-per-cpu=4GB parameter (total 400GB) has no direct equivalent in flux-submit.
# The job may fail due to insufficient memory.
# The --qos parameter has no direct equivalent in flux-submit.

#module load R/4.2.3 gnu openblas
module load R/4.3.2 gnu openblas

export R_HOME="/opt/cres/lib/hpc/gcc7/R/4.2.3/lib64/R"
export LD_LIBRARY_PATH="/opt/cres/lib/hpc/gcc7/R/4.2.3/lib64/R/lib"

# The SLURM_CPUS_PER_TASK variable has been replaced with FLUX_CORES_PER_TASK
julia --threads ${FLUX_CORES_PER_TASK} scripts/06_rate_shift_type_inference.jl > logs/rate_shift_type_inference.txt
