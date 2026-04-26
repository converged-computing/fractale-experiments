#!/bin/bash

let nnds=8
#--- process processexe.pl to change the number of nodes
./processcp.pl ${nnds}

#-----This part creates a submission script---------
cat >batch.job <<EOF
#!/bin/bash
#FLUX: --nodes=${nnds}
#FLUX: --time-limit=60m
#FLUX: --job-name=runs${nnds}
# The -q and -A cobalt directives are ignored.

module load miniconda-3/latest
source activate yt

python3 -m ytopt.search.ambs --evaluator ray --problem problem.Problem --max-evals=3 --learner RF


EOF
#-----This part submits the script you just created--------------
chmod +x batch.job
# The qsub command is replaced with flux submit
flux submit batch.job
