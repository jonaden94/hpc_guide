# 1. Submitting a job

* The default way of using an HPC cluster is to submit so-called "jobs". Jobs on the NHR and SCC are submitted via the Slurm Workload Manager. Slurm batch scripts have a specific syntax that is used to specify which compute resources you request for your job. For example, a standard slurm batch script will look like this:
```
#!/bin/bash
#SBATCH -p grete:shared   # partition to submit job to
#SBATCH -G A100:1         # number of GPUs
#SBATCH -t 0-00:01:00     # time limit in days-hours:minutes:seconds

# define directory to log output to
OUTPUT_DIR="$HOME/output"
mkdir -p $OUTPUT_DIR  # Ensure the directory exists
exec > "$OUTPUT_DIR/job-${SLURM_JOB_ID}.out" 2>&1

# activate conda
echo "activating conda"
source $HOME/scratch/scratch_emmy/conda/etc/profile.d/conda.sh
conda activate torch_env

# running python script
echo "running script"
python $HOME/repos/hpc_guide/2_request_resources/batch_job/train.py
echo "Python script executed"

```
* You specify the characteristics of the compute resource and other parameters of your job via lines beginning with #SBATCH. A comprehensive list of slurm options can be found [here](https://slurm.schedmd.com/sbatch.html).
* A specification of the available compute nodes (e.g. grete:shared in the first SBATCH line) and their characteristics on the SCC and NHR can be found [here](https://docs.hpc.gwdg.de/how_to_use/compute_partitions/gpu_partitions/index.html#the-cpus-and-gpus)
* Below the SBATCH specifications, you should put everything that is related to running your functionality that uses the requested resources. For example, in the example script given above this involves (1) defining an output file, (2) initializing and activating conda, and (3) running the training script 
* Running the example script displayed above can be done by using the following command. The example is a minimal pytorch training script:
```
sbatch 2_request_resources/submit_job/train_nhr.sh # if on NHR
sbatch 2_request_resources/submit_job/train_scc.sh # if on SCC
```
* You can inspect the output of the training script at ``~/output``

# 2. Using compute resources interactively in an ipython notebook
* Sometimes you might want to use compute resources like a GPU interactively for debugging or in an ipython notebook. To achieve this, you should first run an "empty" batch script that does nothing, but also does not terminate because you add a ``sleep infinity`` command:
```
#!/bin/bash
#SBATCH -p grete:interactive            # this is a partition with slices of a GPU
#SBATCH -G 1g.20gb # 1g.20gb or 2g.10gb # Request 10gb or 20gb slices
#SBATCH -t 0-01:00:00                   # requested time

sleep infinity
```
* You can run this script with:
```
sbatch 2_request_resources/interactive/interactive_nhr.sh # if on NHR
sbatch 2_request_resources/interactive/interactive_scc.sh # if on SCC
```
* Then you need to check which node your job has been allocated to by running:
```
squeue --me
```
* For example, the output might look like this, which means that the job is on node ggpu159:
```
6162082 grete:intera interactive.   u12041 nib00034   RUNNING       0:07     1 ggpu159
```
* You can then ssh into this node via jumphost. This means that you ssh to the compute node via the login node since direct ssh-ing to the compute node is not possible. To do this, you need to add the following specification to the ssh config file. Information on how to modify the ssh config file is given on the gwdg pad related to this guide.
```
Host ggpu159 # adapt based on the compute node you have been assigned to
   User your_username
   ProxyJump your_login_node # nhr_login or scc_login
```
* You can then simply use the ``remote-ssh`` extension of VS Code to ssh to the compute node (just as you did to ssh to the login node) and use the resources interactively. For example, you can open the notebook located at ``2_request_resources/interactive/notebook.ipynb`` to create a tensor and put it on a GPU.


# 3. Further slurm commands
* There are some useful slurm shell commands to monitor your jobs or the availability of resources. You already saw ``squeue`` above. Other commands are:
    * sinfo -p partition_name # get info about partition (how many nodes are available at the moment etc.)
    * scancel your_job-id     # cancel your job. This is e.g. important to free interactive resources that you do not need anymore
* scancel is important if jobs get stuck or you want terminate an interactive session that is running on ``sleep infinity``. It is important to free resources so that others can use them.
* A comprehensive list of slurm commands can be found [here](https://curc.readthedocs.io/en/latest/running-jobs/slurm-commands.html)
