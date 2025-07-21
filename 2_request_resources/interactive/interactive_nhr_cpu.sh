#!/bin/bash
#SBATCH -p standard96s:shared           # CPU partition
#SBATCH --cpus-per-task=8               # number of CPU cores to allocate
#SBATCH -t 0-01:00:00                   # time limit in days-hours:minutes:seconds
#SBATCH -A scc_uwvn_kneib               # name of the compute project you are in
#SBATCH --output=/dev/null              # you can delete this line. Then it will automatically log stdout to current_work_dir/output/<jobid>.out
#SBATCH --error=/dev/null               # you can delete this line. Then it will automatically log stderr to current_work_dir/output/<jobid>.out

# optionally put "#SBATCH -C inet as slurm option" and comment out the below lines for internet access on compute node (e.g. for downloading/uploading stuff)
# export HTTPS_PROXY="http://www-cache.gwdg.de:3128"
# export HTTP_PROXY="http://www-cache.gwdg.de:3128"

sleep infinity
