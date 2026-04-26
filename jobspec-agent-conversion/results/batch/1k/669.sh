#!/bin/bash
#FLUX: --job-name=hddqn_agent
#FLUX: --ntasks=1
#FLUX: --cores-per-task=32
#FLUX: --gpus-per-task=1
#FLUX: --output=hddqn_agent.log

# Load modules and activate python environment
module use /opt/easybuild/modules/all/
module load Python3.10 Xvfb freeglut glew MuJoCo
source $HOME/.pyvenvs/rl/bin/activate


# Run the script
python run_hdddqn.py --cuda --gym-id $1 --total-timesteps 1000000 --capture-video --track --update-freq 5 --pre-train-steps 50000
