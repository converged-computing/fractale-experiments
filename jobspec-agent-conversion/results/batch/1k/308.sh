#!/bin/bash -l
#FLUX: --nodes=1
#FLUX: --time-limit=3m
#FLUX: --output=log.slurm.stdOut

# The following 'cd' is optional in Flux, as the default behavior is to start in the submission directory.
# cd $SLURM_SUBMIT_DIR

# Production
#source /project/projectdirs/atom/atom-install-edison/ips-wrappers/env.ips.edison 
# Devel
#source /project/projectdirs/atom/atom-install-edison/ips-wrappers-devel/env.ips.edison 
# Greendl1
#source /project/projectdirs/atom/users/greendl1/code/ips-wrappers/env.ips.edison 
# tyounkin
source /project/projectdirs/atom/users/tyounkin/ips-examples/ftridyn_ea_task_pool/env.ips.edison

#$IPS_PATH/bin/ips.py --config=ips.config --platform=edison_ompi.conf --log=log.framework 2>>log.stdErr 1>>log.stdOut
$IPS_PATH/bin/ips.py --config=ips.config --platform=conf.ips.edison --log=log.framework 2>>log.stdErr 1>>log.stdOut
egrep -i 'error' log.* > log.errors
./setPermissions.sh
