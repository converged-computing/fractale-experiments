#! /bin/bash
#
#FLUX: -N 1
#FLUX: --tasks-per-node=32
#FLUX: -t 30m
#
# The Slurm partition '-p dev_q' was ignored as per instructions.
#

#
module reset
module load NAMD
#
echo "NAMD_TINKERCLIFFS ROME: Normal beginning of execution."
#
#  We need the following files in this directory:
#
#    par_all27_prot_lipid.inp
#    ubq_wb.pdb
#    ubq_wb.psf
#    ubq_wb_eq.conf
#
ls -la
#
#  Run the program with 32 MPI processes using flux mini run.
#
flux mini run -n 32 namd2 ./ubq_wb_eq.conf > namd_tinkercliffs_rome.txt
if [ $? -ne 0 ]; then
  echo "NAMD_TINKERCLIFFS ROME: Run error."
  exit 1
fi
#
echo "NAMD_TINKERCLIFFS ROME: Normal end of execution."
exit 0
