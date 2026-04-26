#!/usr/bin/env sh
#FLUX: --job-name=install_deps
#FLUX: --output=logs/dependencies.log
#FLUX: --error=logs/dependencies.err
#FLUX: --ntasks=2
#FLUX: --nodes=1


#module load R/4.2.3 gnu openblas
module load R/4.3.2 gnu openblas

export R_HOME="/opt/cres/lib/hpc/gcc7/R/4.2.3/lib64/R"
export LD_LIBRARY_PATH="/opt/cres/lib/hpc/gcc7/R/4.2.3/lib64/R/lib"
julia scripts/setup/dependencies.jl > logs/jldep.txt
#Rscript scripts/setup/dependencies.R > logs/Rdep.txt
#julia --threads 8 script.jl > output/screen.txt
