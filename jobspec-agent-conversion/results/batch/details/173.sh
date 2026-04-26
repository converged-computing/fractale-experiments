#!/usr/bin/env sh
#FLUX: --job-name=rate_shift_type
# The --mail-type, --mail-user, and --qos directives are ignored as per instructions.
# The --mem-per-cpu=4GB directive has no direct flux analog and is omitted.
#FLUX: --output=logs/rate_shift_type.log
#FLUX: --error=logs/rate_shift_type.err
#FLUX: --ntasks=1
#FLUX: --nodes=1
#FLUX: --cores-per-task=100
# The --partition directive is ignored as per instructions.

#module load R/4.2.3 gnu openblas
module load R/4.3.2 gnu openblas

export R_HOME="/opt/cres/lib/hpc/gcc7/R/4.2.3/lib64/R"
export LD_LIBRARY_PATH="/opt/cres/lib/hpc/gcc7/R/4.2.3/lib64/R/lib"

# The SLURM_CPUS_PER_TASK variable is replaced with FLUX_JOB_NCORES, which for a single-task job is equivalent.
julia --threads ${FLUX_JOB_NCORES} scripts/06_rate_shift_type_inference.jl > logs/rate_shift_type_inference.txt
