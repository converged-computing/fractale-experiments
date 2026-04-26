#!/bin/bash
#FLUX: --queue=qcpu_exp
#FLUX: --bank=DD-23-135
#FLUX: --ntasks=1
#FLUX: --time-limit=10m
#FLUX: --job-name=AVS-vtune

# The SLURM '--comment' directive has no direct Flux analog.
# The SLURM '--mail-type' directive has no direct Flux analog.

# Flux jobs start in the submission directory by default.

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
