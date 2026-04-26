#!/bin/sh

#FLUX: -n 1
#FLUX: -c 32
#FLUX: -g 1
#FLUX: -t 4h
#FLUX: --output=seq.out

# The SLURM directive '--mem=64G' was omitted as it has no direct Flux translation.
# The SLURM directive '--gres=gpu:nvidia_a30:1' was translated to a generic GPU request (-g 1).
# The specific model constraint ('nvidia_a30') was omitted.
# Account and partition directives were ignored as per instructions.

# No idea why this is necessary, something
# with slurm and the FPGA
export XILINX_XRT=/opt/xilinx/xrt

if [ "$#" -ne 4 ]; then
    printf 'Usage: run.sh N ITERATIONS RUNS OUT_DIR\n\n' >&2
    printf '\tN: Number of bodies\n\n' >&2
    printf '\tITERATIONS: Number of advancements in the benchmark\n\n' >&2
    printf '\tRUNS: How often to run the benchmark\n\n' >&2
    printf '\tOUT_DIR: Directory to store benchmark results.\n\n' >&2
    exit 1
fi

n="$1"
iter="$2"
runs="$3"
outfile="$4/nbody_${n}_${iter}_seq_C"
mkdir -p "$4"

make clean
make -j2

printf 'p,mean,stddev\n' > "${outfile}"
printf '1,' >> "${outfile}"

i=1
{
while [ $i -le "$runs" ]
do
    ./nbody_bench "$n" "$iter"
    i=$(( i + 1 ))
done
} | variance >> "$outfile"
