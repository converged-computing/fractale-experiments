#!/bin/bash
#FLUX: --nodes=1
#FLUX: --time-limit=8h
#FLUX: --output=log-gcc.out

# This script assumes you have pre-loaded the required modules
# prior to submission. The environment will propagate to the batch job.

# The SLURM_... variables were replaced with the Flux equivalent.
echo "print FLUX_JOB_ID = $FLUX_JOB_ID"

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
