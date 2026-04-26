#!/bin/bash
#FLUX: --time-limit=7d
#FLUX: --ntasks=4

module load R4
Rscript --vanilla ../run_BASiCS_commandline.R Blood_SC Blood CD4-Tem
