#!/bin/bash
#FLUX: --job-name=smilei
#FLUX: --nodes=1
#FLUX: --tasks-per-node=1
#FLUX: --ntasks=1


# 'srun' is replaced with 'flux run'
flux run -n 1 /home/reynaldo.rojas/smilei/Smilei/Smilei-benchmarks/plasma_collision_4/1_procs/smilei /home/reynaldo.rojas/smilei/Smilei/Smilei-benchmarks/plasma_collision_4/1_procs/plasma_collision.py
