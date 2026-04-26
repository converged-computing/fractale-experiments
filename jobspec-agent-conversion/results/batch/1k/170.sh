#!/bin/bash
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: --time-limit=5d
#FLUX: --job-name=NFmaster

reads=$1
reference=$2
output=$3
structure1=$4
structure2=$5

module load NextFlow/19.10.0

nextflow \
-c ~/CODE/core/workflows/umi/umi_nextflow.config \
run ~/CODE/core/workflows/umi/umi_preprocess.nf \
-with-trace \
-with-timeline nf_umi-consensus_timeline.htm \
-with-report nf_umi-consensus_report.htm \
--reads $reads \
--reference $reference \
--output_dir $output \
--read_structure1 $structure1 \
--read_structure2 $structure2
