#!/bin/bash

#FLUX: --nodes=1
#FLUX: --ntasks=4
#FLUX: --time-limit=10m

module load valgrind-3.15.0
module load mpich-3.2

# 4 cpu
flux run -n 4 valgrind --leak-check=full --show-leak-kinds=all ./shaker_huffman/bin/MPI_compress /home/shaker.khandaker/inputFiles/1000_words.txt /home/shaker.khandaker/encodedFiles/04_1000_words_encoded.bin
