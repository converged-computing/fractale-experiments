#!/bin/bash
#FLUX: --job-name={{ job_name }}
# The -q (queue) directive is ignored.
#FLUX: --cwd={{ job_workspace }}
# The timestamp logic from the original template is not standard and is omitted.
#FLUX: --output={{ job_name }}.out
#FLUX: --error={{ job_name }}.out

# The -R "rusage[mem...]]" directive for memory has no direct Flux analog and is omitted.

# The logic from the original LSF script is translated below.
# Note that some LSF-specific features like MIG requests have no direct equivalent.

#FLUX: --nodes={{ nodes|default:1 }}
{% if gpu_per_node or use_gpu %}
#FLUX: --ntasks={{ nodes|default:1|multi:cores_per_node|default:1 }}
#FLUX: --cores-per-task=1
#FLUX: --gpus-per-node={{ gpu_per_node|default:1 }}
# The 'j_exclusive=yes' option is translated to --exclusive
#FLUX: --exclusive
# The MIG resource name has no direct analog and is omitted.
{% else %}
#FLUX: --ntasks={{ nodes|default:1|multi:cores_per_node|default:1 }}
{% endif %}
{% if run_time %}#FLUX: --time-limit={% format_lsf_walltime run_time %}{% endif %}

# LSB_JOBID is replaced with FLUX_JOB_ID
ENV_JOB_ID=$FLUX_JOB_ID
