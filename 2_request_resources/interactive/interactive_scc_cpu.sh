#!/bin/bash
#SBATCH -p medium # partition to submit job to (scc-cpu or sgiz are also possible)
#SBATCH -c 8 # number of CPU cores to allocate
#SBATCH -t 0-01:00:00 # time limit in days-hours:minutes:seconds
#SBATCH -A scc_uwvn_kneib # name of the compute project you are in
#SBATCH --output=/dev/null # no output log is generated
#SBATCH --error=/dev/null # no error log is generated

############## OPTIONAL SLURM ARGS
# put "#SBATCH -C inet as slurm option" and comment out the below lines for internet access on compute node (e.g. for downloading/uploading stuff)
# export HTTPS_PROXY="http://www-cache.gwdg.de:3128"
# export HTTP_PROXY="http://www-cache.gwdg.de:3128"

sleep infinity # make sure the job does not exit immediately so that you can ssh to the granted compute node
