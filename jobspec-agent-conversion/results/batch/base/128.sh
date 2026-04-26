#!/bin/bash
#FLUX: --nodes=1
#FLUX: --time-limit=8h
#Note: This script assumes you have pre-loaded the required modules
#prior to submitting the job. The env will propagate to the
#batch job.
#FLUX: --output=log-gcc.out

# The original script checked for SLURM_PROCID=0. This is simplified
# to just print the Flux Job ID if it exists.
if [ -n "$FLUX_JOB_ID" ]
then
  echo "print FLUX_JOB_ID = $FLUX_JOB_ID"
fi 

cd /home/projects/albany/nightlyCDashTrilinosBlake
source blake_gcc_modules.sh >& gcc_modules.out
bash nightly_cron_script_trilinos_blake_gcc_release.sh
bash nightly_cron_script_trilinos_blake_gcc_debug.sh
cd /home/projects/albany/nightlyCDashAlbanyBlake
bash nightly_cron_script_albany_blake_gcc_release.sh
bash nightly_cron_script_albany_blake_gcc_debug.sh
bash nightly_cron_script_albany_blake_gcc_sfad.sh sfad6
bash nightly_cron_script_albany_blake_gcc_sfad.sh sfad12
bash nightly_cron_script_albany_blake_gcc_sfad.sh sfad24
bash nightly_cron_script_mali_blake_gcc_release.sh
