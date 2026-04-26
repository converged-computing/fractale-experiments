#!/bin/bash -l
#FLUX: --job-name=precip
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: --time-limit=5h

export TMPDIR=/glade/scratch/$USER/temp
mkdir -p $TMPDIR

# module load ncarenv python/3.7.9
# unset DASK_ROOT_CONFIG
source /glade/work/jamesmcc/python_envs/379zr/bin/activate

python /glade/u/home/jamesmcc/WRF_Hydro/rechunk_retro_nwm_v21/precip/precip_to_zarr.py > /glade/scratch/jamesmcc/retro_collect/precip/precip_log

exit 0

