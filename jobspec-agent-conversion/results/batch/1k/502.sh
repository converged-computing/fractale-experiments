#!/bin/bash
#FLUX: --tasks-per-node=32
#FLUX: --exclusive
#FLUX: --nodes=2

# The --nodelist and --mem=0 directives have no direct analog in the provided flux submit options.
# The --partition directive was ignored as per instructions.

# Clear the environment from any previously loaded modules
module purge > /dev/null 2>&1
module use /opt/site/easybuild/modules/all/Core
module load GCC/9.3.0 OpenMPI/4.0.3
# Load the module environment suitable for the job
echo "Starting job at: "
date
./mhd_run
echo "Finished"
date
