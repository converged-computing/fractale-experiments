#!/bin/bash
#FLUX: --ntasks=1 
#FLUX: --cores-per-task=16
#FLUX: --output=ejecutor_%J.out
#FLUX: --error=ejecutor_%J.err
#FLUX: --job-name=ejecutor
#FLUX: --time-limit=48h

python get_cardinalities_3D_arrays.py top5_combos.all pdb.list.BM5
#/apps/GREASY/2.1.2.1/bin/greasy ROTSPIN.txt
#apps/GREASY/2.1.2.1/bin/greasy ordenes_bm4_zdock.txt
#python get_just_ligand_1KKL.py;
#python get_just_ligand_1N2C.py;
#python get_just_ligand_1Y64.py;
#python get_just_ligand_1XU1.py;
#python get_just_ligand_1F51.py;
