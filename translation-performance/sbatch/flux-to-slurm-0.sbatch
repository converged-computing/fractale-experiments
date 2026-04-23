json
{
  "jobspec": "#!/bin/bash\n#SBATCH --nodes=1\n#SBATCH --ntasks=64\n\necho \"Start time:\" $( date +%s )\nsrun --mpi=pmix lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns\necho \"End time:\" $( date +%s )\n"
}