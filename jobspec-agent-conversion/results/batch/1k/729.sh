#!/bin/bash
#FLUX: --ntasks=1 
#FLUX: --output=lsf.out
#FLUX: --error=lsf.err
#FLUX: --job-name=module2 

# The LSF generic resource request for a GPU (-R gpu) has no direct analog and was omitted.
# The LSF resource request for processor tiling (-R "span[ptile=2]") has no direct analog and was omitted.

###========================================
#---------------------------------------------------------------------
# The mpirun command has been replaced with flux mini run
flux mini run -n 1 ./ImageColorToGrayscale_Solution -e ./output.pbm -i input.ppm -t image > grayscale_output.txt
###end of script
