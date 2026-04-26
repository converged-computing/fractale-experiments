#!/bin/bash
#FLUX: --job-name=gw_amr
#FLUX: --time-limit=20m
#FLUX: --ntasks=16

source ./modules.sh

flux run -n 16 julia --project=. -e'
  using GadiTutorial;
  main_amr(;nprocs=16,nrefs=4,num_amr_steps=6)
'
