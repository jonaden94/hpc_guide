#!/bin/bash
#SBATCH -p jupyter # partition to submit job to (scc-gpu for more powerful GPUs)
#SBATCH -G RTX5000:1 # specify which gpu to request and how many e.g. V100:2 (A100 and H100 are available on scc-gpu)
#SBATCH -t 0-01:00:00 # time limit in days-hours:minutes:seconds
#SBATCH -A scc_uwvn_kneib # name of the compute project you are in
#SBATCH --output=/dev/null # no output log is generated
#SBATCH --error=/dev/null # no error log is generated

############## OPTIONAL SLURM ARGS
# put "#SBATCH -C inet as slurm option" and comment out the below lines for internet access on compute node (e.g. for downloading/uploading stuff)
# export HTTPS_PROXY="http://www-cache.gwdg.de:3128"
# export HTTP_PROXY="http://www-cache.gwdg.de:3128"

sleep infinity # make sure the job does not exit immediately so that you can ssh to the granted compute node
