#!/bin/bash

#FLUX: --job-name=compile_intel_MBX
#FLUX: --time-limit=1h
#FLUX: --nodes=1
#FLUX: --cores=16
#FLUX: --error=stderr
#FLUX: --output=stdout


export MBX_HOME=$HOME/software/MBX

module loadgnu intel gsl openmpi_ib fftw
export PATH=$FFTWHOME/lib:$FFTWHOME/include:$PATH

cd $MBX_HOME 
rm -rf build install
cmake -DCMAKE_BUILD_TYPE=Debug -DUSE_OPENMP=True -DCMAKE_CXX_FLAGS=" -fPIC -O2 -Wall -L$FFTWHOME/lib -I$FFTWHOME/include" -DCMAKE_CXX_COMPILER=icpc -DCMAKE_C_COMPILER=icc -H. -Bbuild
cd build
make -j 8 CXX=icpc CC=icc
make install
cd ../

# Compile the driver
cd plugins/i-pi/src/main
cp Makefile_tscc_intel Makefile
make
cd -
