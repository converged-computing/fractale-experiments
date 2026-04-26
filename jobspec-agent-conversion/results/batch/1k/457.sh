#!/bin/bash
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=1
#FLUX: --cores-per-task=1
#FLUX: --time-limit=5m
#FLUX: --job-name=test
#FLUX: --output=test-%j.out
#FLUX: --error=test-%j.err


echo "building active";
#0 is integers, 1 is float, 2 is doubles
dtype=0
optimizer=0
make clean
make DTYPE=$dtype OPT=$optimizer
num=1
until [ $num -gt 5 ]; do
	time=1
    until [ $time -gt 3 ]; do
        #valgrind --tool=cachegrind --cache-sim=yes bin/runnable_$dtype $num >out_$num\_$time
        bin/runnable_$dtype $num >Homework_runs/no_optimization/int/out_$num\_$time\_$dtype\.txt
        time=$(($time+1))
    done
	num=$(($num+1))
done
