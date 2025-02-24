#!/bin/bash
#SBATCH -p gpu              # partition to submit job to
#SBATCH -G 1                # optionally specify which gpu to request and how many e.g. V100:2
#SBATCH -t 01:00:00         # time limit in hours:minutes:seconds
#SBATCH --output=/dev/null  # you can delete this line. Then it will automatically log stdout to current_work_dir/output/<jobid>.out
#SBATCH --error=/dev/null   # you can delete this line. Then it will automatically log stderr to current_work_dir/output/<jobid>.out

# optionally put "#SBATCH -C inet as slurm option" and comment out the below lines for internet access on compute node (e.g. for downloading/uploading stuff)
# export HTTPS_PROXY="http://www-cache.gwdg.de:3128"
# export HTTP_PROXY="http://www-cache.gwdg.de:3128"

source /user/henrich1/u12041/.bashrc
export HTTPS_PROXY="http://www-cache.gwdg.de:3128"
export HTTP_PROXY="http://www-cache.gwdg.de:3128"
sleep infinity
