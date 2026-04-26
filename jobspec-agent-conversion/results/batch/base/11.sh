#!/bin/bash -l
#FLUX: --requires=knl
#FLUX: --cores-per-task=1
#FLUX: --ntasks=1
#FLUX: --nodes=1
#FLUX: --time-limit=30m
#FLUX: --job-name=job-1b
#FLUX: --output=stats/job-1b.o{id}
#FLUX: --error=stats/job-1b.e{id}

# The --qos=debug parameter from slurm has no direct equivalent in flux-submit.
# The --cpu-freq=1400000 parameter from slurm has no direct equivalent in flux-submit.
# Performance may vary from the original script due to different CPU frequency.


# set some openmp variables: 
# OMP_PLACES=threads maps OpenMP threads to hardware threads
# OMP_PROC_BIND=spread binds threads as evenly as possible
#
# see https://docs.nersc.gov/jobs/affinity/ for more information

export OMP_PLACES=threads
export OMP_PROC_BIND=spread

export OMP_SCHEDULE=static
# export OMP_SCHEDULE=dynamic

for t in 1
   do
   export OMP_NUM_THREADS=$t
   for r in 256
      do
      for p in 1 2 4 8 16
         do
         for b in 8
            do
            build/ray -r $r -p $p -b $b
         done
      done
   done
done
