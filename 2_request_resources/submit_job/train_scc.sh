#!/bin/bash
#SBATCH -p gpu          # gpu partition
#SBATCH -G 1            # optionally specify which gpu to request and how many e.g. V100:2
#SBATCH -t 01:00:00

# export HTTPS_PROXY="http://www-cache.gwdg.de:3128" # optional for being able to download/upload stuff from/to the internet on the compute node
# export HTTP_PROXY="http://www-cache.gwdg.de:3128" # optional for being able to download/upload stuff from/to the internet on the compute node

# define directory to log output to
OUTPUT_DIR="$HOME/output"
mkdir -p $OUTPUT_DIR  # Ensure the directory exists
exec > "$OUTPUT_DIR/job-${SLURM_JOB_ID}.out" 2>&1

# activate conda
echo "activating conda"
source $HOME/scratch/conda/etc/profile.d/conda.sh
conda activate torch_env

# running python script
echo "running script"
python $HOME/repos/hpc_guide/2_request_resources/batch_job/train.py
echo "Python script executed"
