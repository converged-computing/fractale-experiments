#!/bin/sh
#FLUX: --job-name=hddm-paper
#FLUX: --nodes=20
#FLUX: --tasks-per-node=8
#FLUX: -t 10h

# NOTE: The PBS directive '#PBS -r n' (job not rerunnable) was omitted as it has no direct Flux equivalent.
# NOTE: The MPI launch command has been updated to use the native 'flux mini run' command.

source hddm_venv2/bin/activate

cd HDDM-paper

echo "Launching controller"
ipcontroller --profile=mpi &
sleep 10

echo "Launching engines"
# The original script used `mpirun` with `$PBS_NODEFILE`.
# The idiomatic way to do this in Flux is with `flux mini run`, which automatically
# uses the nodes and resources allocated to the job.
flux mini run -n 160 ipengine --profile=mpi &
sleep 10

echo "Launching job"
python ~/HDDM-paper/run_estimation.py -r -a --profile mpi --parallel --all -st -sz -z
