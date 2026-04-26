#!/bin/bash -l

#FLUX: --job-name=mat2fem
#FLUX: --time-limit=1d
#FLUX: --nodes=1
#FLUX: --output=out.txt
#FLUX: --error=err.txt



source /cluster/bin/jobsetup
module purge
module load matlab/R2017a
module load python2/2.7.10
module load gcc/7.2.0

if [ $# -eq 0 ];then
	echo "Give the number of patients added to seg as an argument. Quitting."
	exit 1
fi
folder=seg/current_patient
data="`date +%d.%m-%H.%M`"
for i in $(seq 1 $1);do
	echo "Working on Patient $i"
	cp seg/Patient_"$i".mat $folder/Patient_1.mat
	python mat2fem.py $i $data
	rm $folder/Patient_1.mat
done
