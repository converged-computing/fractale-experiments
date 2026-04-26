#!/bin/sh
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: --time-limit=2h
#FLUX: --job-name=run

# The PBS directive to join output/error streams (-j oe) has no analog and was omitted.
# The PBS directive to make the job non-rerunnable (-r n) has no analog and was omitted.

####################

# PBS's $PBS_O_WORKDIR is equivalent to Flux's $FLUX_SUBMIT_DIR
cd $FLUX_SUBMIT_DIR
. env.sh

# 実行したいコマンド
python example.py
