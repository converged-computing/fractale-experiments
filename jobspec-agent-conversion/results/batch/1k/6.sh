#!/bin/bash
#FLUX: --time-limit=24h
#FLUX: --job-name=pico
# The --mail-user and --mail-type directives are ignored.
#FLUX: --error=./pico.err.%j
#FLUX: --output=./pico.out.%j
#FLUX: --ntasks=1
#FLUX: --cores-per-task=16
# The --mem-per-cpu=8182 directive has no direct flux analog and is omitted.
# The --exclusive directive is ambiguous without -N. Assuming exclusive access to the node.
#FLUX: --nodes=1
#FLUX: --exclusive
# The -C avx (constraint) directive is translated to a requirement.
#FLUX: --requires=avx

# ----------------------------------


module load intel python/3.6.8
python -u ./src/run_pico_experiments.py
