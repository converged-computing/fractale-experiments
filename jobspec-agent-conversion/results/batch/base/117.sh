#!/bin/bash
#FLUX: --ntasks=1 
#FLUX: --output=ejecutor_{id}.out
#FLUX: --error=ejecutor_{id}.err
#FLUX: --job-name=ejecutor
#FLUX: --cores-per-task=16
#FLUX: --time-limit=48h

# The LSF directive -R"span[ptile=16]" was interpreted as a request for 16 cores for the single task.

python get_cardinalities_3D_arrays.py top5_combos.all pdb.list.BM5
#/apps/GREASY/2.1.2.1/bin/greasy ROTSPIN.txt
#apps/GREASY/2.1.2.1/bin/greasy ordenes_bm4_zdock.txt
#python get_just_ligand_1KKL.py;
#python get_just_ligand_1N2C.py;
#python get_just_ligand_1Y64.py;
#python get_just_ligand_1XU1.py;
#python get_just_ligand_1F51.py;

