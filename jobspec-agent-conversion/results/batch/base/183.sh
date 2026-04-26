#!/bin/bash
#FLUX: --job-name=land_use
#FLUX: --bank=POLARIS
#FLUX: -q bdwall
#FLUX: --nodes=1
#FLUX: -t 30h

# NOTE: The SLURM directives '--mail-user' and '--mail-type' were omitted as there are no direct Flux equivalents.

set -eu

main() {
    cd /lcrc/project/POLARIS/bebop/SMART_FY22_LAND_USE/PILATES-SRC-JA
    module_load
    setup_venv
    . venv/bin/activate
    python3 ./run.py "$@"
}

setup_venv() {
    python3 -m pip install --user virtualenv
    [[ -d venv ]] || virtualenv venv
    . venv/bin/activate
    # python3 -m pip install -r requirements.txt
}

module_load() {

    # BEBOP
    module load gcc/10.2.0-z53hda3
    module load python/3.8.10-6kl7zkj
    module load singularity/3.6.4

    python3 -m ensurepip --upgrade
}

main "$@"
