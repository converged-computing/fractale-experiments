#!/bin/bash -fx
#FLUX: --ntasks=1
#FLUX: --cores-per-task=32

  echo flux node: $(hostname) , jobid: $FLUX_JOB_ID
  module load fiberseq-rs
  python fibseq_rust.py $1 $2
