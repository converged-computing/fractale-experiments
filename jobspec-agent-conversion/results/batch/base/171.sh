#!/bin/bash
#FLUX: --job-name=100c100
#FLUX: --queue=stampede
#FLUX: --cc=0-2
# The output directive below uses {id} as a placeholder for the unique job ID of each task
# and $FLUX_JOB_CC for the job collection task ID. The exact syntax is not documented and should be verified.
#FLUX: --output=/home-mscluster/npather/disentangle/100c100.{id}_$FLUX_JOB_CC.txt

# NOTE: If your script uses the Slurm job array task ID (e.g., from the
# $SLURM_ARRAY_TASK_ID environment variable), it must be modified to use
# the Flux equivalent, $FLUX_JOB_CC.

python3 main.py \
--aicrowd_challenge=false \
--name=100c100 \
--alg=BetaVAE \
--traverse_z=true \
--traverse_c=true \
--dset_dir=/home-mscluster/npather/disentanglement-pytorch/data/dsprites \
--dset_name=dsprites_full \
--encoder=PadlessGaussianConv64 \
--decoder=SimpleConv64 \
--discriminator=SimpleDiscriminator \
--z_dim=20 \
--use_wandb=true \
--w_kld=1.0 \
--w_tc=9.0 \
--lr_G=0.001 \
--lr_scheduler=ReduceLROnPlateau \
--lr_scheduler_args mode=min factor=0.95 patience=1 min_lr=0.00005 \
--max_iter=90000 \
--iterations_c=90000 \
--max_c=100 \
--evaluation_metric mig sap_score irs dci beta_vae_sklearn factor_vae_metric \
--alg=BetaVAE \
--loss_terms \
--use_bandit=false \
--controlled_capacity_increase=true \
--loss_txt=false \
--wandb_project_name=anneal \
--qma_alpha=0.001 \
--boltzmann_lambda=15
