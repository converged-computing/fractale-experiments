#!/bin/bash
#FLUX: --error=./error%j.txt
#FLUX: --output=./output%j.txt
#FLUX: --job-name=WRF_forecast
#FLUX: --ntasks=160
#FLUX: --time-limit=1d16h


# NOTE: The %j format specifier is not supported in Flux; files will be overwritten.

# first set the environemt
export NETCDF=/appl/opt/netcdf4/gcc-7.3.0/intelmpi-18.0.2/4.6.1/
module purge
module load gcc/7.3.0  intelmpi/18.0.2 hdf5-par/1.8.20 netcdf4/4.6.1
export WRFIO_NCD_LARGE_FILE_SUPPORT=1


exe_wrf=wrf.exe

## run my MPI executable
# 'srun' is replaced with 'flux run'
flux run -n 160 ${exe_wrf}
