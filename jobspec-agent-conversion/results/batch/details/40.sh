#!/bin/bash
# The -A (account) directive is ignored.
#FLUX: --job-name=SM_HSP_dimer_prod
#FLUX: --error=job.%j.err
#FLUX: --output=job.%j.out
#FLUX: --time-limit=24h
# The Slurm directives -n 20 and -c 1 are interpreted as a request for a single threaded process using 20 cores, based on the `gmx mdrun -nt 20` command.
#FLUX: --ntasks=1
#FLUX: --cores-per-task=20

# It is always best to do a ml purge before loading modules in a submit file
ml purge
ml ABINIT/8.10.3 Armadillo/9.700.2 CDO/1.9.5 GOTM/5.3-221-gac7ec88d NCO/4.8.1 NCO/4.9.2 OpenFOAM/6 OpenFOAM/7 OpenFOAM/v1912 Rosetta/3.7 Siesta/4.1-MaX-1.0 Siesta/4.1-b4 Singular/4.1.2 XCrySDen/1.5.60 XCrySDen/1.6.2 deal.II/9.1.1-gcc deal.II/9.1.1-intel

ml gromacs/2019.6.th

gmx grompp -f md.mdp -c npt.gro -t npt.cpt -p topol.top -o md_0_1.tpr

# The gmx mdrun command does not need a parallel launcher in this context.
gmx mdrun -nt 20 -deffnm md_0_1
