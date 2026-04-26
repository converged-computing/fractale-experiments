#!/bin/bash
#FLUX: --job-name=SpTrSv_Final
#FLUX: --output=SpTrSv_Final_${FLUX_JOB_ID}.out
#FLUX: --error=SpTrSv_Final_${FLUX_JOB_ID}.error
#FLUX: --nodes=1
#FLUX: --ntasks=64
#FLUX: --time-limit=6h

# The SLURM directive '#SBATCH --export=ALL' is assumed to be the default behavior in Flux, which exports the current environment.

source init_var.sh
export OMP_NUM_THREADS=64
export MKL_NUM_THREADS=64

SOURCE_DIR=$(pwd)
echo "Start SpTrSv Final"
cd ${SOURCE_DIR}/build/example
rm -rf SpTrSv_Final_20.csv
for sparse_mat in matrix/*.mtx;
do
    echo "Processing ${sparse_mat}"
    # Since this is not an MPI application, it can be run directly within the job script.
    ./SpTrSv_Final ${sparse_mat}
done
