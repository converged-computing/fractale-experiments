#!/bin/sh
#FLUX: --job-name={{ job_name }}
#FLUX: --output={{ log_file | /dev/null }}
#FLUX: --error={{ log_file | /dev/null }}
#FLUX: --ntasks=1
#FLUX: --cores-per-task={{ n_cpus }}
#FLUX: --cc=1-{{ n_jobs }}

spack load r@3.5.3

CMQ_AUTH={{ auth }} R --no-save --no-restore -e 'clustermq:::worker("{{ master }}")'
