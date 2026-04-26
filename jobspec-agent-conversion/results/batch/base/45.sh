#!/bin/bash
#FLUX: --queue=physical
#FLUX: --time-limit=10m
#FLUX: --nodes=1
#FLUX: --ntasks=1

# Load required modules
module load Python/3.5.2-goolf-2015a

# Execute Python Job on 1 node and 1 core
echo "Cluster and Cloud Computing Assignment1 using 1 node and 1 core"

# The mpiexec command is replaced by flux run. The number of tasks is taken from the job directives.
time flux run python3 HPCInstagramGeoProcessingUsingMPI.py melbGrid.json bigInstagram.json
