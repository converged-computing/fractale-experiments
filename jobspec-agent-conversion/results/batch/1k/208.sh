#!/bin/bash -l
#FLUX: --env=-*
#FLUX: -t 6h
#FLUX: -n 6

# The SLURM directive '--mem=64GB' was omitted as it has no direct Flux translation.
# The SLURM directive '--export=NONE' was translated to '--env=-*'.
# Partition and mail directives were ignored as per instructions.

start=`date +%s`

module load singularity
shopt -s expand_aliases
source /astro/mwasci/sprabu/aliases

set -x
{

obsnum=OBSNUM
base=BASE
myPath=MYPATH
link=

while getopts 'l:' OPTION
do
    case "$OPTION" in
        l)
            link=${OPTARG}
            ;;
    esac
done


cd ${base}/processing/
mkdir ${obsnum}
cd ${obsnum}

## move existing ms (for birli testing)
mv ${obsnum}.ms old${obsnum}.ms

wget -O ${obsnum}_ms.tar "${link}"
tar -xvf ${obsnum}_ms.tar

end=`date +%s`
runtime=$((end-start))
echo "the job run time ${runtime}"

}
