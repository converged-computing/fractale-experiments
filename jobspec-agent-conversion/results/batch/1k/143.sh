#!/bin/bash
#FLUX: --job-name=dbcan_rumen-v1-bacteria_06
#FLUX: --output=dbcan_rumen-v1-bacteria_06.out
#FLUX: --time=16:00:00
#FLUX: --nodes=1
#FLUX: --ntasks=48

START=$SECONDS

cd  /fs/scratch/PAS0439/Ming/databases/mgnify-rumen-v1.0/genomes/bacteria

module load python/3.6-conda5.2
source activate /fs/ess/PAS0439/MING/conda/run_dbcan

for j in $(ls | tail -n +2001 |head -n 400 );
do run_dbcan ${j} prok --out_dir /fs/scratch/PAS0439/Ming/results/dbcan_res/rumen-v1 -t hmmer --hmm_cpu 48  --db_dir /fs/ess/PAS0439/MING/conda/run_dbcan/db  --out_pre ${j%.fna}_
done
DURATION=$(( SECONDS - START ))

echo "Completed in $DURATION seconds."
