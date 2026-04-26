#!/bin/bash
#FLUX: --job-name=bead-select
# The -l procs=1 is translated to ntasks=1
#FLUX: --ntasks=1
#FLUX: --time-limit=100h
# The mem=7GB directive has no direct flux analog and is omitted.
# The -q WitsLong (queue) directive is ignored as per instructions.
# The PBS job array directive `-t 0-1024` is handled by submitting this script with `flux submit --cc=0-1024`

hostname

cd  /spaces/scott/chip/pool_selection/

# The PBS_ARRAYID variable is replaced with FLUX_JOB_CC for job arrays
run=${FLUX_JOB_CC}

/usr/bin/time  python pool_select.py --input all.cpickle --label S${LABEL} --bad badscore60.lst --requests extra.lst,req_func_u.scores --factor 1.5 $run 10 18
