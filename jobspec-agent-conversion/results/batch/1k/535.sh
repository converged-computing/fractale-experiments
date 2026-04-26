#!/bin/bash
#FLUX: --time-limit=24h
#FLUX: --cwd=/home/gscarpellini/Positional_Puzzle

# Run the program.

module load go-1.19.4/apptainer-1.1.8 

#module load openmpi/4.0.5/gcc7-ib


echo "$pyfile"

singularity run --nv -B ./:/app -B /work/gscarpellini:/work/gscarpellini singularity/singularity.sif bash /app/singularity/gianscarpe/run_Script_args.sh $pyfile "$args" #$1
