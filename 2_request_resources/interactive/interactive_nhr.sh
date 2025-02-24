#!/bin/bash
#SBATCH -p grete:interactive            # this is a partition with slices of a GPU
#SBATCH -G 1g.20gb # 1g.20gb or 2g.10gb # Request 10gb or 20gb slices
#SBATCH -t 0-01:00:00                   # time limit in days-hours:minutes:seconds
#SBATCH --output=/dev/null              # you can delete this line. Then it will automatically log stdout to current_work_dir/output/<jobid>.out
#SBATCH --error=/dev/null               # you can delete this line. Then it will automatically log stderr to current_work_dir/output/<jobid>.out

# optionally put "#SBATCH -C inet as slurm option" and comment out the below lines for internet access on compute node (e.g. for downloading/uploading stuff)
# export HTTPS_PROXY="http://www-cache.gwdg.de:3128"
# export HTTP_PROXY="http://www-cache.gwdg.de:3128"

source /user/henrich1/u12041/.bashrc
export HTTPS_PROXY="http://www-cache.gwdg.de:3128"
export HTTP_PROXY="http://www-cache.gwdg.de:3128"
sleep infinity
