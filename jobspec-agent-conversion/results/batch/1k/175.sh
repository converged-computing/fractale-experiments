#!/bin/bash
#FLUX: --job-name=download_data
#FLUX: -t 6h
#FLUX: -n 1
#FLUX: -c 6
#FLUX: --output=outfile.txt
#FLUX: --error=errfile.txt

# The SLURM directive '--mem=32G' was omitted as it has no direct Flux translation.
# The SLURM directive '--nodelist=compute-21' was omitted as there is no direct generic Flux translation.


# This is the code to run
singularity run --mount type=bind,src=$(pwd),dst=/rootvol /mnt/beegfs/singularity/images/data_download_nextflow.sif run nf-core/fetchngs --max_memory 31GB --max_cpus 6 --input /rootvol/ids.csv --outdir /rootvol/

