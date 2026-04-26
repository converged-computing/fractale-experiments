#!/bin/bash
#FLUX: --nodes=1
#FLUX: --cores=20
#FLUX: --time-limit=3d
#FLUX: --job-name=bionoi_autoencoder_mlp



module purge
source activate pytorch
cd /work/wshi6/deeplearning-data/BionoiNet-prj/BionoiNet/bionoi_ml_homology_reduced/
#python mlp_autoencoder_vec.py -op control_vs_nucleotide -result_file_suffix 1th_run > ./mlp_autoencoder_vec_log/control_vs_nucleotide_mlp_autoencoder_1th_run.log 2>&1
python mlp_autoencoder_vec.py -op control_vs_heme -result_file_suffix 1th_run > ./mlp_autoencoder_vec_log/control_vs_heme_mlp_autoencoder_1th_run.log 2>&1



