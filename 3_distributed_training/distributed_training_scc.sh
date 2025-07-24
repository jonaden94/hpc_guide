#!/bin/bash
#SBATCH -p gpu
#SBATCH --nodes=1                 # node count (can also increase for multi-node training)
#SBATCH --gpus-per-node=RTX5000:2 # total number of gpus per node
#SBATCH --ntasks-per-node=2       # total number of tasks per node
#SBATCH --cpus-per-task=1         # cpu-cores per task (>1 if multi-threaded tasks)
#SBATCH --time=00:05:00           # total run time limit (HH:MM:SS)
#SBATCH --output=/dev/null        # you can delete this line. Then it will automatically log stdout to current_work_dir/output/<jobid>.out
#SBATCH --error=/dev/null         # you can delete this line. Then it will automatically log stderr to current_work_dir/output/<jobid>.out

# optionally put "#SBATCH -C inet as slurm option" and comment out the below lines for internet access on compute node (e.g. for downloading/uploading stuff)
# export HTTPS_PROXY="http://www-cache.gwdg.de:3128"
# export HTTP_PROXY="http://www-cache.gwdg.de:3128"

# define directory to log output to
OUTPUT_DIR="$HOME/slurm_logs"
mkdir -p $OUTPUT_DIR  # Ensure the directory exists
exec > "$OUTPUT_DIR/job-${SLURM_JOB_ID}.out" 2>&1

echo "Activating conda..."
source ~/.bashrc
conda activate torch_env

# These environment variables are required for initializing distributed training in pytorch  
export MASTER_PORT=29400
export MASTER_ADDR=$(scontrol show hostnames "$SLURM_JOB_NODELIST" | head -n 1)
export WORLD_SIZE=$(($SLURM_NNODES * $SLURM_NTASKS_PER_NODE))

echo "MASTER_PORT="$MASTER_PORT
echo "WORLD_SIZE="$WORLD_SIZE
echo "MASTER_ADDR="$MASTER_ADDR
srun python $HOME/repos/hpc_guide/3_distributed_training/distributed_training.py

# By default, errors in a distributed setup are often silent, making debugging difficult.
# To get more precise information for debugging, try running training scripts with (some of) the following environment variables:
# CUDA_LAUNCH_BLOCKING=1 TORCH_DISTRIBUTED_DEBUG=DETAIL NCCL_DEBUG=INFO NCCL_IB_DISABLE=1 srun python train.py