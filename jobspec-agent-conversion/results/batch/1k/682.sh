#!/bin/bash
#FLUX: -t 72h
#FLUX: --cores=20
#FLUX: --cc=1-9

# The slurm memory request (--mem) has no direct analog in flux and has been omitted.
# The slurm node feature constraint (-C intel) has no direct analog and was omitted.

sleep $((FLUX_JOB_CC*60))

set -e

# NOTE: Flux does not have direct equivalents for SLURM_CPUS_ON_NODE or SLURM_MEM_PER_NODE.
# We will use the total requested cores as a substitute for thread count.
export AGALMA_DB="/gpfs/data/cdunn/analyses/agalma-siphonophora-20170501_reduced.sqlite"
export BIOLITE_RESOURCES="threads=20,memory=120000M" # Manually setting memory from original --mem request

IDS=(
	HWI-ST625-159-C4MVCACXX-5-CCGTCC
	HWI-ST625-159-C4MVCACXX-5-AGTTCC
	HWI-ST625-159-C4MVCACXX-5-GTCCGC
	HWI-ST625-159-C4MVCACXX-5-TGACCA
	HWI-ST625-181-C76K5ACXX-2-ATCACG
	HWI-ST625-181-C76K5ACXX-2-ACTTGA
	HWI-ST625-181-C76K5ACXX-2-TAGCTT
	HWI-ST625-181-C76K5ACXX-2-GGCTAC
	HWI-ST625-181-C76K5ACXX-2-CTTGTA
	K00162-189-HJTYGBBXX-7-NCAGTG
)

# SLURM_ARRAY_TASK_ID is replaced by FLUX_JOB_CC
ID=${IDS[$FLUX_JOB_CC-1]}
echo $ID

agalma transcriptome --id $ID --ss RF
