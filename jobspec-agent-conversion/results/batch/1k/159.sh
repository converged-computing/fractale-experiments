#!/bin/bash
#FLUX: --job-name='{{ job_name|addslashes }}'
#FLUX: --cwd={{ job_workspace }}
{% if gpu_per_node %}
#FLUX: --tasks-per-node={{ cores_per_node|default:1 }}
#FLUX: --nodes={{ nodes|default:1 }}
#FLUX: --gpus-per-node={{ gpu_per_node }}
{% else %}
#FLUX: --ntasks={{ cores_per_node|default:1 }}
{% endif %}
{% if run_time %}#FLUX: --time-limit={{ run_time|timeformat }}{% endif %}

# The slurm memory request (--mem) has no direct analog in flux and has been omitted from this template.
# The slurm ability to request a specific GPU type (--gres={{ gpu_resource_name }}) has no analog and was omitted.

# SLURM_JOB_ID is replaced by FLUX_JOB_ID
ENV_JOB_ID=$FLUX_JOB_ID
