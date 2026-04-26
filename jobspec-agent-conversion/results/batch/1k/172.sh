#!/bin/bash

#FLUX: --job-name=growth
#FLUX: --time-limit=<walltime>
#FLUX: --nodes=1
#FLUX: --ntasks=<num_proc>

# The PBS '-j oe' directive is handled by directing both output streams to the same file.
#FLUX: --output="<out_folder>/${FLUX_JOB_ID}.out"
#FLUX: --error="<out_folder>/${FLUX_JOB_ID}.out"

# Flux jobs are typically started in the submission directory, so 'cd $PBS_O_WORKDIR' is not needed.

PROJECT_HOME="<project_home>"

PYTHONPATH="$PROJECT_HOME/libs:$PYTHONPATH"
export PYTHONPATH

if [ -d "$PROJECT_HOME/venv" ]; then
	source "$PROJECT_HOME"/venv/bin/activate
	echo "Virtualenv at $PROJECT_HOME/venv activated."
else
	echo "WARNING: Virtualenv not found/activated! Using system python & LAMMPS..."
fi

# The PBS_JOBID is replaced by FLUX_JOB_ID
JOB_ID=$( expr match "${FLUX_JOB_ID}" '\([0-9]*\)' )
SEED=$(( 10#${JOB_ID} % 900000000 ))

# The mpiexec command is replaced by the standard Flux launcher 'flux mini run'.
# The number of tasks is taken from the placeholder <num_proc>.
/usr/bin/time --verbose flux mini run -n <num_proc> python "$PROJECT_HOME"/programs/growth.py "<cfg_file>" "<run_file>" <simlen> --seed $SEED <args>

run_filename=`basename "<run_file>"`
run_filename="${run_filename%.*}"
python "$PROJECT_HOME"/tools/dump_processing.py "<cfg_file>" "<out_folder>/${run_filename}_${SEED}.dump" -c -l <aargs>
