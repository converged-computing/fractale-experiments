#!/bin/bash
#FLUX: --error=./error%j.txt
#FLUX: --output=./output%j.txt
#FLUX: --job-name=flex
#FLUX: --ntasks=1
#FLUX: --time-limit=1d


# NOTE: The %j format specifier is not supported in Flux; files will be overwritten.

# first set the environemt
export NETCDF=/appl/opt/netcdf4/gcc-7.3.0/intelmpi-18.0.2/4.6.1/
module purge
module load gcc/7.3.0  intelmpi/18.0.2 hdf5-par/1.8.20 netcdf4/4.6.1
export WRFIO_NCD_LARGE_FILE_SUPPORT=1

#flex_dir='/homeappl/home/aliagadi/appl_taito/flexpart/Src_flexwrf_v3.3.2-omp/examples'
flex_dir='/homeappl/home/aliagadi/appl_taito/FLEXPART-WRF_v3.3.2'
input_flex=/homeappl/home/aliagadi/wrk/DONOTREMOVE/flexpart_management_data/runs/run_2020-01-03_19-44-36_/2018-05-22/flx_input
cd $flex_dir
#exe=flexwrf33_gnu_mpi
#exe=flexwrf33_gnu_omp
#exe=flexwrf33_gnu_serial
exe=flexwrf33_gnu_serial
## run my MPI executable
# srun is not required for a single task job in Flux
$exe $input_flex
