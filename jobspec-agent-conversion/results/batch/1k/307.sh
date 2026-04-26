#! /bin/bash

#FLUX: --job-name=test_job
#FLUX: --nodes=1
#FLUX: --ntasks-per-node=1
#FLUX: --cores-per-task=1


module load CUDA
module load apps/matlab/2017a

cd /mnt/storage/home/csprh/code/HAB/extractData/postProcess
#matlab -nodisplay -nosplash -r getDataOuter > outfile.txt < /dev/null 
matlab -nodisplay -nosplash -r cubeAnalysis_1
