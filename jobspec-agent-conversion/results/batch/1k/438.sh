#!/bin/bash
#FLUX: --job-name=StressObjEq
#FLUX: --nodes=1
#FLUX: --cores=16
#FLUX: --time-limit=8h

source /etc/profile.d/modules.sh
module purge
module add matlab/2014a

# Flux jobs are typically started in the submission directory ($PBS_O_WORKDIR)
# so a 'cd' command is not necessary.

rm *.csv

mcc -R -nodisplay  -m  GAOptimizationMain_v2_Single.m FEALevelSetWrapperGA_v2.m FEALevelSet_2D_v8.m constr2_v2.m objfun2_v2.m outPutFunction.m

./GAOptimizationMain_v2_Single 1
