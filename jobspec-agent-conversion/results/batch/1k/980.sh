#! /bin/bash
#FLUX: --ntasks=1
#FLUX: --cores-per-task=12
#FLUX: --time-limit=3d


module purge
module load nextflow
module load singularity
module load graphviz

nextflow run nf-core/atacseq -r dev --input /data/capaldobj/lgcp/senatorov-et-al-2023/design.csv \
-profile biowulf \
--aligner bwa \
--genome GRCh37 \
--igenomes_base 's3://ngi-igenomes/igenomes' \
--read_length 75 \
--outdir '/data/LGCP/freedman-chip/lucap-only-k27ac-results/'
