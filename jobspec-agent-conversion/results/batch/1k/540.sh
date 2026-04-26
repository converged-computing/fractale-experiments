#!/bin/bash

#FLUX: --nodes=1
#FLUX: --tasks-per-node=1
#FLUX: --time-limit=4h
#FLUX: --cores-per-task=1
#FLUX: --gpus-per-node=1
#FLUX: --requires=pascal

source load_modules_qbig_pascal.sh
#export KOKKOS_PROFILE_LIBRARY=/hiskp4/garofalo/chemHMC/code/external/kokkos-tools/kp_memory_events.so
# export KOKKOS_PROFILE_LIBRARY=/hiskp4/garofalo/chemHMC/code/external/kokkos-tools/kp_kernel_logger.so

 
#rm rng* out_xyz.txt
#/qbigwork/garofalo/valgrind/install_dir/bin/valgrind --leak-check=full ../../chemHMC/code/build/main//main -i input_I.yaml
#../../chemHMC/code/build/main//main -i input_I.yaml
#main/main -i ../test.yaml
#./test/test 
#./test/test_binning -i ../test.yaml                                         
