#!/bin/bash

#FLUX: --job-name=BUSCO
#FLUX: --time-limit=20h
#FLUX: --cores=104

# The following PBS directives could not be translated:
# -l mem=512GB
# -j oe
# -l storage=gdata/xl04+gdata/if89
# -l jobfs=100GB

module load singularity

#inputs : fasta, outpath

lineage=/g/data/xl04/bpadata/Bassiana_duperreyi/projects/chromsyn/busco_downloads
prefix=$(basename "${fasta}" .fasta)
cd ${outpath}

# The PBS_NCPUS variable has been replaced with the requested number of CPUs.
singularity exec /g/data/xl04/ka6418/docker_images/busco-5.4.7.sif busco -o run_$prefix --offline -i $fasta -l sauropsida_odb10 --download_path $lineage --cpu 104 -m genome --tar
