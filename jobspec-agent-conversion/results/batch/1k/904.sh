#!/bin/sh

# Modified from https://github.com/mschubert/clustermq/blob/master/inst/SLURM.tmpl
# under the Apache 2.0 license.

#FLUX: --job-name=floating_hamster_{{ job_name }}
#FLUX: --output={{ log_file | /dev/null }}
#FLUX: --error={{ log_file | /dev/null }}
#FLUX: --cc=1-{{ n_jobs }}
#FLUX: --cores-per-task={{ cores | 1 }}
#FLUX: --ntasks=1
#FLUX: --time-limit={{ time | 00:60:00 }}

module load R/4.1.0 # Comment out if R is not an environment module.
# ulimit -v $(( 1024 * {{ memory | 4096 }} ))
CMQ_AUTH={{ auth }} R --no-save --no-restore -e 'clustermq:::worker("{{ master }}")'

