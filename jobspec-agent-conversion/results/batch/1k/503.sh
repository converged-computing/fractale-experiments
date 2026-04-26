#!/bin/bash
#FLUX: --job-name=fb-uf
#FLUX: --nodes=1
#FLUX: --cores=16
#FLUX: --time-limit=7h

# Flux jobs are typically started in the submission directory, so 'cd $PBS_O_WORKDIR' is not needed.
cd ..
module load gcc/4.8.1 python/3.4
./msparse -i ~/test_graphs/fb-uf.edges -n 35111 --weak --zero-index -o out/fb-uf_coarsest.txt -r 1 --level-span 3 --sparse-level 0 -s 0.3
./msparse -i ~/test_graphs/fb-uf.edges -n 35111 --weak --zero-index -o out/fb-uf_mid.txt -r 1 --level-span 3 --sparse-level 1 -s 0.3
./msparse -i ~/test_graphs/fb-uf.edges -n 35111 --weak --zero-index -o out/fb-uf_finest.txt -r 1 --level-span 3 --sparse-level 2 -s 0.3
python3 benchmark.py fb-uf /home/emmanuj/test_graphs/fb-uf.edges
