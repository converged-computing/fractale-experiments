#!/bin/bash
#SBATCH --nodes=2
#SBATCH --ntasks=128

# Record start time
echo "Start time:" $( date +%s )

# Run the application
srun kripke --niter 100 --zones 64,64,64 --procs 4,8,4

# Record end time
echo "End time:" $( date +%s )