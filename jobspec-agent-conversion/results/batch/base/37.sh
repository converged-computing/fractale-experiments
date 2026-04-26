#!/bin/bash

#FLUX: --job-name=analysis
#FLUX: --queue=batch
#FLUX: --time-limit=<walltime>
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --output="<out_folder>/{id}.out"
#FLUX: --error="<out_folder>/{id}.err"

# The PBS memory request '-l pmem=<memory>' has no direct equivalent in flux-submit.
# The job may be scheduled on a node without enough memory.
# The PBS option to join stdout and stderr ('-j oe') is not supported; separate files will be created.


# The 'cd $PBS_O_WORKDIR' command is not needed as Flux jobs start in the submission directory by default.

PROJECT_HOME="<project_home>"

PYTHONPATH="$PROJECT_HOME/libs:$PYTHONPATH"
export PYTHONPATH

if [ -d "$PROJECT_HOME/venv" ]; then
	source "$PROJECT_HOME"/venv/bin/activate
	echo "Virtualenv at $PROJECT_HOME/venv activated."
else
	echo "WARNING: Virtualenv not found/activated! Using system python & LAMMPS..."
fi

python "$PROJECT_HOME"/tools/dump_processing.py "<cfg_file>" <aargs>
