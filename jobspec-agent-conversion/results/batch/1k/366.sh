#!/bin/sh

#FLUX: --time-limit=1h
#FLUX: --nodes=1
#FLUX: --cores=1

# The following Flux directives are placeholders. Flux batch directives are static
# and cannot use the $dname variable. You must either manually edit the values below
# or submit the job via the command line.
#FLUX: --error=/home/laine/PROJECTS_IO/SIMULATION/LOG/MAKE_PHANTOM/placeholder.err
#FLUX: --output=/home/laine/PROJECTS_IO/SIMULATION/LOG/MAKE_PHANTOM/placeholder.out

# The PBS memory request (-l mem=20GB) has no direct analog in the provided flux submit options.
# The mail directives (-m, -M) were ignored as per instructions.

# --- RUN THE SCRIPT
cd /misc/raid/home/laine/REPOSITORIES/CCA_DL_TOOLS/SIMULATION/mtl_cores

echo $pfolder
echo $dname
echo $pres
echo $pparam
echo $info

process="matlab -r fct_run_mk_phantom('$pfolder','$dname','$pres','$pparam','$info')"

echo $process
$process
