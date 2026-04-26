#!/bin/bash

#FLUX: --ntasks=8 

module load NAMD/2.13-GCC-7.3.0-2.30-OpenMPI-3.1.1

flux run -n 8 namd2 stmv.namd


