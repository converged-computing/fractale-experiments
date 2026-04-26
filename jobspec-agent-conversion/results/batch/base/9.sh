#!/bin/bash

#FLUX: --job-name=BUSCO
#FLUX: --bank=xl04
#FLUX: --queue=normalsr
#FLUX: --time-limit=20h
#FLUX: --cores=104
#FLUX: --ntasks=1
#FLUX: --output=BUSCO.o$FLUX_JOB_ID
#FLUX: --error=BUSCO.e$FLUX_JOB_ID

# The PBS memory request 'mem=512GB' has no direct Flux analog in the provided documentation.
# The PBS 'storage' and 'jobfs' requests are site-specific and have no direct Flux analog.
# The PBS email notification directive '-M' has no direct Flux analog.
# The PBS 'wd' directive is default behavior in Flux.

module load singularity

#inputs : fasta, outpath

lineage=/g/data/xl04/bpadata/Bassiana_duperreyi/projects/chromsyn/busco_downloads
prefix=$(basename "${fasta}" .fasta)
cd ${outpath}

singularity exec /g/data/xl04/ka6418/docker_images/busco-5.4.7.sif busco -o run_$prefix --offline -i $fasta -l sauropsida_odb10 --download_path $lineage --cpu ${FLUX_JOB_NPROC} -m genome --tar
