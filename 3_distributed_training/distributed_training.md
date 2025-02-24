# Distributed training

* The Slurm Workload Manager can also be used to request multiple GPUs or even multiple GPU nodes (each GPU node contains 4-8 GPUs) at once. Especially the NHR offers enough resources to enable large scale training of neural networks.
* To request multiple GPUs or multiple nodes, you just have to change a slurm options at the top of the batch script. The following example, requests 2 GPUs on one node:
```
#!/bin/bash
#SBATCH -p grete
#SBATCH --nodes=1                # node count (can also increase for multi-node training)
#SBATCH --gpus-per-node=A100:2   # total number of gpus per node
#SBATCH --ntasks-per-node=2      # total number of tasks per node
#SBATCH --cpus-per-task=1        # cpu-cores per task (>1 if multi-threaded tasks)
#SBATCH --time=00:05:00          # total run time limit (HH:MM:SS)
#SBATCH --output=/dev/null       # you can delete this line. Then it will automatically log stdout to current_work_dir/output/<jobid>.out
#SBATCH --error=/dev/null        # you can delete this line. Then it will automatically log stderr to current_work_dir/output/<jobid>.out

# define directory to log output to
OUTPUT_DIR="$HOME/output"
mkdir -p $OUTPUT_DIR  # Ensure the directory exists
exec > "$OUTPUT_DIR/job-${SLURM_JOB_ID}.out" 2>&1

echo "Activating conda..."
source $HOME/scratch/scratch_emmy/conda/etc/profile.d/conda.sh
conda activate torch_env

# These environment variables are required for initializing distributed training in pytorch  
export MASTER_PORT=29400
export MASTER_ADDR=$(scontrol show hostnames "$SLURM_JOB_NODELIST" | head -n 1)
export WORLD_SIZE=$(($SLURM_NNODES * $SLURM_NTASKS_PER_NODE))

echo "MASTER_PORT="$MASTER_PORT
echo "WORLD_SIZE="$WORLD_SIZE
echo "MASTER_ADDR="$MASTER_ADDR
srun python $HOME/repos/hpc_guide/3_distributed_training/distributed_training.py
```
* Of course, you also need to make some modifications to the training script so that multiple processes are launched that are then communicating with each other. A minimal example distributed training script based on pytorch is located at ``3_distributed_training/distributed_training.py``, which is called in the example above with ``srun``. ``srun`` is used to launch parallel jobs, which are able to communicate with each other if needed.
* To run distributed training on 2 GPUs, run the following command:
```
sbatch 3_distributed_training/distributed_training_nhr.sh # if on NHR
sbatch 3_distributed_training/distributed_training_scc.sh # if on SCC
```
* Feel free to increase the number of nodes to two or also the number of GPUs to four to use more resources for distributed training. Note, however, that this might lead to larger waiting times in case the resources are not available.
* See [here](https://pytorch.org/tutorials/distributed/home.html) for more information on distributed training in pytorch.