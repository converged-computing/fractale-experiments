#!/usr/bin/bash
#FLUX: --cores-per-task=6
#FLUX: --ntasks=1
#FLUX: --time-limit=3h
#FLUX: --job-name=build_container
#FLUX: --requires=amd

# If no root is available the system must offer --fakeroot. Otherwise use sudo.
singularity build --fakeroot --force lofar_sksp_v4.0.2_znver2_znver2_noavx512_aocl_cuda_ddf.sif Singularity.amd_aocl
