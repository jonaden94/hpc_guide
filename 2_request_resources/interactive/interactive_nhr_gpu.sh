#!/bin/bash
#SBATCH -p grete:interactive # this is a partition with slices of a GPU
#SBATCH -G 1g.20gb # 1g.10gb or 1g.20gb # Request 10gb or 20gb slices
#SBATCH -t 0-01:00:00 # time limit in days-hours:minutes:seconds
#SBATCH -A scc_uwvn_kneib # name of the compute project you are in
#SBATCH --output=/dev/null # no output log is generated (comment out by adding an extra # to the beginning of the line)
#SBATCH --error=/dev/null # no output log is generated (comment out by adding an extra # to the beginning of the line)

############## OPTIONAL SLURM ARGS
### 1. 
# put "#SBATCH -C inet as slurm option" and comment out the below lines for internet access on compute node (e.g. for downloading/uploading stuff)
# export HTTPS_PROXY="http://www-cache.gwdg.de:3128"
# export HTTP_PROXY="http://www-cache.gwdg.de:3128"
### 2.
# use these two lines instead of the ones above to log output and errors to a file
#SBATCH --output=slurm_logs/slurm_log_%j.log # use this line instead of the one above to log output to a file
#SBATCH --error=slurm_logs/slurm_log_%j.log # use this line instead of the one above to log errors to a file

sleep infinity # make sure the job does not exit immediately so that you can ssh to the granted compute node
