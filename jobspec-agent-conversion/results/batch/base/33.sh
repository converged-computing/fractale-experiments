{# Flux Job Submission Template #}
#!/bin/bash
#FLUX: --job-name={{ job_name }}
#FLUX: --queue={{ job_queue }}
#FLUX: --cwd={{ job_workspace }}
{# Note: LSF's timestamped output file is replaced with Flux's job ID. #}
{# LSF's joined output/error is not supported; creating separate files. #}
#FLUX: --output={{ job_name }}-{id}.out
#FLUX: --error={{ job_name }}-{id}.err

{# Note: The LSF memory request ('rusage[mem=...]'') has no direct equivalent in flux-submit. #}
{# The job may be scheduled on a node without enough memory. #}

#FLUX: --nodes={{ nodes|default:1 }}

{% if gpu_per_node or use_gpu %}
#FLUX: --tasks-per-node={{ cores_per_node|default:1 }}
#FLUX: --gpus-per-node={{ gpu_per_node|default:1 }}
{% if gpu_resource_name %}#FLUX: --requires={{ gpu_resource_name }}{% endif %}
{# Note: Exclusive GPU access (j_exclusive=yes) is generally the default behavior when requesting GPUs in Flux. #}
{% else %}
#FLUX: --tasks-per-node={{ cores_per_node|default:1 }}
{% endif %}
{% if run_time %}#FLUX: --time-limit={{ run_time }}{% endif %}

ENV_JOB_ID=$FLUX_JOB_ID
