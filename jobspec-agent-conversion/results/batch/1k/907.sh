#!/bin/bash
# The -p qcpu_exp, -A DD-23-135, and --mail-type END directives are ignored as per instructions.
#FLUX: --ntasks=1
# The --comment directive has no direct flux analog and is omitted.
#FLUX: --time-limit=10m
#FLUX: --job-name=AVS-vtune

# The SLURM_SUBMIT_DIR variable is replaced by FLUX_JOB_CWD
cd $FLUX_JOB_CWD

ml intel-compilers/2022.1.0 CMake/3.23.1-GCCcore-11.3.0 VTune/2022.2.0-intel-2021b

[ -d build_vtune ] && rm -rf build_vtune
[ -d build_vtune ] || mkdir build_vtune
cd build_vtune

CC=icc CXX=icpc cmake ..
make

for threads in 18 36; do
    for builder in "ref" "loop" "tree"; do
        rm -rf vtune-${builder}-${threads}
        vtune -collect threading -r vtune-${builder}-${threads} -app-working-dir . -- ./PMC --builder ${builder} -t ${threads} --grid 128 ../data/bun_zipper_res3.pts
    done
done
