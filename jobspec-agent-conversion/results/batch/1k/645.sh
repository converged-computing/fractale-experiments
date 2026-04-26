#!/bin/bash --login
#FLUX: --time-limit=10m
#FLUX: --nodes=1
#FLUX: --cores=2
#FLUX: --job-name=gg_denovo_cda

# NOTE: Flux jobs typically start in the submission directory, so 'cd $PBS_O_WORKDIR' is not needed.
# cd $PBS_O_WORKDIR

# Load modules and qiime
module load miniconda/python2

# Setting temporary directory
mkdir -p ~/qiime_tmp
export TMPDIR=~/qiime_tmp

# Loading virtualenv
echo "loading virtualenv"
# NB qiime1 and not qiimel (number one not letter l)
source activate qiime1

# Procrustes analysis on weighted and unweighted UniFrac PCoA matrices
time transform_coordinate_matrices.py \
-i unweighted_unifrac_dm.txt,weighted_unifrac_dm.txt \
-r 999 \
-o /lustre/home/d411/alorax1/data/2018/procrustes_output

# Generating a Procrustes plot
time make_emperor.py \
-c \
-i /lustre/home/d411/alorax1/data/2018/procrustes_output/ \
-o /lustre/home/d411/alorax1/data/2018/procrustes_output/plots \
-m /lustre/home/d411/alorax1/test/all/allyears_map.txt

source deactivate
