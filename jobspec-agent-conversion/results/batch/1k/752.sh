#!/bin/bash
#FLUX: --job-name=abinit
#FLUX: --exclusive
#FLUX: --tasks-per-node=8
#FLUX: --nodes=8
#FLUX: --ntasks=64
#FLUX: --output=../output/reorder=8_64_4.out


cd ../
source ./env.sh

matrix=(audikw_1 bone010 dielFilterV2real asia_osm ldoor nlpkkt80 rajat31 rgg_n_2_21_s0 road_central inline_1 hugebubbles-00000 germany_osm italy_osm adaptive ecology1 vas_stokes_1M AS365 M6 NLR cant)

export UCX_LOG_LEVEL=error

for((i=0;i<20;i++))
do
	# 'mpirun' is replaced with 'flux run'
    flux run -n 64 ./reorder ../matrix/${matrix[${i}]}.mtx 4
done 
