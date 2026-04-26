#!/bin/bash

#FLUX: --job-name=snowCCI2000
#FLUX: --nodes=1
#FLUX: --cores=16
#FLUX: --time-limit=8h
#FLUX: --output=debug/snowCCI_preprocess_MODIS_gricad_v1-2000.out
#FLUX: --error=debug/snowCCI_preprocess_MODIS_gricad_v1-2000.err

# The OAR parameter for job type (-t fat) has no direct analog and was omitted.

python snowCCI_preprocess_MODIS_gricad_v1-2000.py
