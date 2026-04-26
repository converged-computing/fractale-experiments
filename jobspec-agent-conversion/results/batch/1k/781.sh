#!/bin/bash
#FLUX: --job-name=valgrind_massif
#FLUX: --nodes=1
#FLUX: --time-limit=17h5m
#FLUX: --ntasks=2
#FLUX: --cores-per-task=24
#FLUX: --cwd=.

# Slurm's dynamic output/error filenames (%j) are not supported in Flux directives.
# We redirect all output for the script using 'exec' and the FLUX_JOB_ID variable.
exec > massif2_${FLUX_JOB_ID}.out 2> massif2_${FLUX_JOB_ID}.err

DIR=map
mkdir massif2
file="massif.out.*"
if [ -f $file ]; then
   rm $file
fi
for i in {1..10}; 
do 
if [ -d "$DIR$i" ]; then
    printf '%s\n' "Removing Lock ($DIR)"
    rm -r "$DIR$i"
fi
export OMP_NUM_THREADS=24
valgrind --tool=massif flux mini run -n 2 ./nest $1 
cd massif2
mkdir map$i
mv ../massif.out.* map$i
#cd map$i
#ms_print  massif.out.* | tail -n 1  >> heap.txt
cd ../
done 
exit
