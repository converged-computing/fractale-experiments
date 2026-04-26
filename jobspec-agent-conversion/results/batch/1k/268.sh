#!/bin/bash
#FLUX: --ntasks=1
#FLUX: --nodes=1

# NOTE: The original script was a job array but was missing the --array directive.
# You must add a --cc directive below for this script to work.
# Example: #FLUX: --cc=1-100

read INPUTPRECOMPUTEDFILE < <( sed -n ${FLUX_JOB_CC}p $1 )

echo "... Loading software"
eval $( spack load --sh /pudl6n3 )
eval $( spack load --sh py-jsonpickle@1.4.1 )
eval $( spack load --sh py-dill@0.3.4 )

#INPUTPRECOMPUTEDFILE=$1
#OUTPUTPICKLEFILE=$2

echo "... Input precomputed file: $INPUTPRECOMPUTEDFILE"

echo "... Start script..."
python3 -u /scratch/hllab/Juan/Ixchel/SourceCode/Ixchel.py SerializePrecomputedPositionsHash $INPUTPRECOMPUTEDFILE
echo "Complete!"
