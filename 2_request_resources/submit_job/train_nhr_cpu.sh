#!/bin/bash
#SBATCH -p standard96s:shared # partition to submit job to
#SBATCH -N 1 # number of nodes to allocate
#SBATCH -n 1 # total number of tasks (distributed across N nodes)
#SBATCH -c 2 # number of CPU cores per task
#SBATCH -t 0-00:05:00 # time limit in days-hours:minutes:seconds
#SBATCH -A scc_uwvn_kneib # name of the compute project you are in
#SBATCH --output=/dev/null # you can delete this line. Then it will automatically log stdout to current_work_dir/output/<jobid>.out
#SBATCH --error=/dev/null # you can delete this line. Then it will automatically log stderr to current_work_dir/output/<jobid>.out

# optionally put "#SBATCH -C inet as slurm option" and comment out the below lines for internet access on compute node (e.g. for downloading/uploading stuff)
# export HTTPS_PROXY="http://www-cache.gwdg.de:3128"
# export HTTP_PROXY="http://www-cache.gwdg.de:3128"

# define directory to log output to
OUTPUT_DIR="$HOME/slurm_logs"
mkdir -p $OUTPUT_DIR  # Ensure the directory exists
exec > "$OUTPUT_DIR/job-${SLURM_JOB_ID}.out" 2>&1

# activate conda
echo "activating conda"
source ~/.bashrc
conda activate torch_env

# running python script
python /user/henrich1/u18550/repos/hpc_guide/2_request_resources/submit_job/train_cpu.py # dummy single model training
