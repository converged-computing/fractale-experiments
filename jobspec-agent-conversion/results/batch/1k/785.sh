#!/bin/bash
#
#FLUX: --job-name=MPET
#

#

#

#
# Max memory usage per task:

#
# Number of tasks (cores):
#FLUX: --nodes=1 
#FLUX: --ntasks=8
#FLUX: --cores-per-task=1
#FLUX: --time=1h


#FLUX: --output=MPET.out

## Set up job environment
source /cluster/bin/jobsetup

echo $SCRATCH

#source ~oyvinev/intro/hashstack/fenics-1.5.0.abel.gnu.conf
source ~oyvinev/fenics1.6/fenics1.6

# Expand pythonpath with locally installed packages
export PYTHONPATH=$PYTHONPATH:$HOME/.local/lib/python2.7/site-packages/

# Define what to do when job is finished (or crashes)
cleanup "mkdir -p /work/users/piersanti/MPET_output"
cleanup "cp -r $SCRATCH /work/users/piersanti/MPET_output"

# Copy necessary files to $SCRATCH
cp -r /usit/abel/u1/piersanti/MPET $SCRATCH

# Enter $SCRATCH and run job
cd $SCRATCH
cd MPET

# 'mpirun' is replaced with 'flux run'
flux run -n 8 python prova.py
