#!/bin/sh
#FLUX: --nodes=1
#FLUX: --cores=32
#FLUX: --time-limit=4d4h
#FLUX: --job-name=CoDECS_LCDM


export PATH=/com/openmpi-1.2.5/bin:$PATH
export LD_LIBRARY_PATH=/com/intel/mkl/10.0.1.014/lib/em64t:/com/openmpi-1.2.5/lib:/com/intel/fce/10.1.017/lib:/com/gsl/1.15/lib


opmpi=/com/openmpi-1.2.5/lib
intel=/com/intel/fce/10.0.023/lib:/com/intel/cce/10.0.023/lib
export LD_LIBRARY_PATH=${opmpi}:${intel}:$LD_LIBRARY_PATH
# NOTE: Flux jobs typically start in the submission directory, so 'cd $PBS_O_WORKDIR' is not needed.
# cd $PBS_O_WORKDIR
export OMP_NUM_THREADS=32

#python hubble.py ../cases/Planck512/Planck512_LSST1.0.yaml
#python hubble.py ../cases/Planck512/Planck512_LSST0.5.yaml
#python hubble.py ../cases/Planck512/Planck512_LSST.yaml
#python hubble.py ../cases/CoDECS_LCDM/LCDM_min_dist_5Mpch-1.yaml
#python hubble.py ../cases/Planck512/Planck512_density_and_velocity_grids.yaml
python hubble.py ../cases/Planck512/Planck512_Nbody_velocitypowerspectrum.yaml

echo "========= Job finished at `date` =========="
