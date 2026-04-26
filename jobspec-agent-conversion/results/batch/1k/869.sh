#!/bin/bash
#FLUX: --nodes=1
#FLUX: --ntasks=4
#FLUX: --time=5h15m
#FLUX: --job-name="unet_train"
#FLUX: --output=/ourdisk/hpc/ai2es/jRobinson/R-%x.%j.out
#FLUX: --error=/ourdisk/hpc/ai2es/jRobinson/R-%x.%j.err

# NOTE: The %x and %j format specifiers are not supported in Flux; files will be overwritten.


#Running using Modules
echo "loading modules"
# module load GCCcore/6.4.0
module load TensorFlow/2.4.1-fosscuda-2020a-Python-3.8.2 
#install 'togo' packages, it will install wheels to use in your local cache, ~/.local/
echo "installing packages"
pip install keras-unet-collection
pip install Pillow
pip install xarray
pip install netCDF4
pip install dask

echo "loading python"
source .bashrc
bash
conda activate hagelslag
echo "running python"
python unet_regression_test7.py
