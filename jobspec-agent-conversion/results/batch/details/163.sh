#!/bin/bash
#FLUX: --job-name="SpTrSv_Final"
#FLUX: --output="SpTrSv_Final_%j.out"
#FLUX: --error="SpTrSv_Final_%j.error"
#FLUX: --nodes=1
#FLUX: --tasks-per-node=64
# The --export=ALL directive is the default behavior in flux and is omitted.
#FLUX: --time-limit=6h

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
    ./SpTrSv_Final ${sparse_mat}
done
