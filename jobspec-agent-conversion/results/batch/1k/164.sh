#!/bin/bash
#MNH_LIC Copyright 1994-2019 CNRS, Meteo-France and Universite Paul Sabatier
#MNH_LIC This is part of the Meso-NH software governed by the CeCILL-C licence
#MNH_LIC version 1. See LICENSE, CeCILL-C_V1-en.txt and CeCILL-C_V1-fr.txt  
#MNH_LIC for details. version 1.
#FLUX: --verbose
#FLUX: --job-name=compile
#FLUX: --time-limit=2h5m
#FLUX: --nodes=1
#FLUX: --ntasks-per-node=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: --output=VUserII.eo   #
#FLUX: --error=VUserII.eo   #

export VER_USER=                ########## Your own USER Directory
set -x

# On va lancer la compilation dans le répertoire de lancement du job
. ../conf/profile_mesonh-LXifort-R8I4-MNH-V5-7-0-${VER_USER}-MPIINTEL-O3

time gmake user
time gmake -j 1 installuser

