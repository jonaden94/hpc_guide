*Note that SCC users cannot run jobs on nodes reserved exclusively for NHR users, and vice versa. This guide provides scripts for both user groups. Make sure to select the ones that apply to you.*

# 1. Submitting a job

* The default way of using an HPC cluster is to submit so-called "jobs". Jobs on the NHR and SCC are submitted via the Slurm Workload Manager. Slurm batch scripts have a specific syntax that is used to specify which compute resources you request for your job. For example, a standard slurm batch script will look like this:
```
#!/bin/bash
#SBATCH -p medium # partition to submit job to (scc-cpu or sgiz are also possible)
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
python $HOME/repos/hpc_guide/2_request_resources/submit_job/train_cpu.py # dummy single model training
```

* You specify the characteristics of the compute resource and other parameters of your job via lines beginning with ``#SBATCH``. A comprehensive list of slurm options can be found [here](https://slurm.schedmd.com/sbatch.html).
* A specification of the available compute nodes (e.g. medium in the first SBATCH line) and their characteristics on the SCC and NHR can be found [here](https://docs.hpc.gwdg.de/how_to_use/compute_partitions/index.html)
* Below the SBATCH specifications, you should put everything that is related to running your functionality that uses the requested resources. For example, in the example script given above this involves (1) defining an output file (in practice, you should find a better way to log your results, though), (2) initializing and activating conda, and (3) running the training script 
* We provide a minimal example for CPU training (random forest) and GPU training (linear model) on both the NHR and SCC. The training scripts can be run using one of the following commands:
```
sbatch 2_request_resources/submit_job/train_nhr_cpu.sh # NHR CPUs
sbatch 2_request_resources/submit_job/train_scc_cpu.sh # SCC CPUs
sbatch 2_request_resources/submit_job/train_nhr_gpu.sh # NHR GPUs
sbatch 2_request_resources/submit_job/train_scc_gpu.sh # SCC GPUs
```

* To see the current status of your job (i.e. whether still in queue or already running), run the following command:
```
squeue --me
```

* These dummy jobs only run for a couple of seconds so that you might not see them anymore.
* You can inspect the output of the training script at ``~/slurm_logs``
* We also provide a minimal example for a job that starts multiple CPU tasks at once. In the dummy example, each task fits a model with a specific hyperparameter configuration. This way, you can e.g. quickly conduct hyperparameter searches in parallel. You can run this dummy hyperparameter search with the following command: 
```
sbatch 2_request_resources/submit_job/tune_hyperparams_nhr_cpu.sh # NHR CPUs
sbatch 2_request_resources/submit_job/tune_hyperparams_scc_cpu.sh # SCC CPUs
```

* When you look at the hyperparameter tuning script, you will see that the python script is called with ``srun``. ``srun`` is used to run the script independently ``n`` times (n specifies the number of tasks slurm option). Based on the task number environment variable, the python script can then choose a unique hyperparameter configuration and fits the model with it.
* Again, the output of the hyperparameter search can be inspected at ``~/slurm_logs``

# 2. Using compute resources interactively in an ipython notebook
* Sometimes you might want to use compute resources interactively for debugging or in an ipython notebook. To achieve this, you should first run an "empty" batch script that does nothing, but also does not terminate because you add a ``sleep infinity`` command:
```
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
```

* You can request interactive CPU/GPU resources on the NHR/SCC using one of the following scripts:
```
sbatch 2_request_resources/interactive/interactive_nhr_cpu.sh # NHR CPUs
sbatch 2_request_resources/interactive/interactive_scc_cpu.sh # SCC CPUs
sbatch 2_request_resources/interactive/interactive_nhr_gpu.sh # NHR GPUs
sbatch 2_request_resources/interactive/interactive_scc_gpu.sh # SCC GPUs
```

* Then you need to check which node your job has been allocated to by running:
```
squeue --me
```

* For example, the output for requesting CPU resources on the SCC might look like this, which means that the job is on node amp052:
```
JOBID    PARTITION         NAME     USER  ACCOUNT     STATE       TIME NODES NODELIST(REASON)
9948643       medium interactive_   u18550 scc_uwvn   RUNNING       0:49     1 amp052
```

* You can then ssh into this node via jumphost. This means that you ssh to the compute node via the login node since direct ssh-ing to the compute node is not possible. As stated earlier in this guide, you need to jumphost via the login node that corresponds to the compute node you are using. You can find a comprehensive list of login nodes and the corresponding compute islands [here](https://docs.hpc.gwdg.de/start_here/connecting/login_nodes_and_example_commands/index.html).
* An example configuration of how to ssh to a CPU compute node on the SCC looks as follows. You need to add this entry to the ssh config file as described [here](https://pad.gwdg.de/SuhRYfSdSMKSybf31eoUfA?view).
```
Host amp052 # adapt based on the compute node you have been assigned to
   User your_username # adapt based on your username
   ProxyJump scc_login # adapt based on the required login node (scc_login, nhr_login_gpu or nhr_login_cpu)
```

* You can then simply use the ``remote-ssh`` extension of VS Code to ssh to the compute node (just as you did to ssh to the login node) and use the resources interactively. For example, you can open the notebook located at ``2_request_resources/interactive/notebook.ipynb`` to create a tensor and put it on a GPU (when using GPU resources) or to fit a random forest with the number of cores you requested (when using CPU resources).
* For GPU computing, interactive jobs should be run on "GPU slices", i.e. one GPU split up so that it can be used by multiple people. This is specified in the batch script with the ``SBATCH -G 1g.20gb`` option. In principle, it is also possible to request interactive jobs for full GPUs.


# 3. Data stores
* So far, we only ran dummy training scripts that do not actually require to load any data or save logs.
* In practice, this is required, which is why it is important to know which data should be saved in which place. 
* There are various different data stores with different properties (memory quota, maximum number of files quota, backup vs. no backup, etc.)
* It is important to know which data store should be used for what.
* A comprehensive description of different data stores can be found [here]([https://docs.hpc.gwdg.de/how_to_use/the_storage_systems/index.html](https://docs.hpc.gwdg.de/how_to_use/storage_systems/index.html))
* One important data store is located at ``.project/dir.project``. The quota there is quite large and it has a backup, which makes it a good place for storing medium-term data.
* However, when your model training requires you to continuously and quickly load files during execution, this might not be the correct place to store your data. When speed is important, you should look into the so-called [workspaces](https://docs.hpc.gwdg.de/how_to_use/the_storage_systems/data_stores/workspaces/index.html). Also, most compute nodes have their own SSD which you can use to load the data on once prior to starting training and then load it from there for fast access.


# 4. Further slurm commands and knowledge
* There are some useful slurm shell commands to monitor your jobs or the availability of resources. You already saw ``squeue`` above. Other commands are:
    * ``sinfo -p partition_name`` # get info about partition (how many nodes are available at the moment etc.)
    * ``scancel your_job-id``     # cancel your job. This is e.g. important to free interactive resources that you do not need anymore
* scancel is important if jobs get stuck or you want terminate an interactive session that is running on ``sleep infinity``. It is important to free resources so that others can use them.
* A comprehensive list of slurm commands can be found [here](https://curc.readthedocs.io/en/latest/running-jobs/slurm-commands.html)
* If you are in an interactive session and want to run a script and then close your notebook, you can make use of the ``tmux`` command. tmux opens its own shell that remains even if you disconnect from the server. A list of useful tmux commands can be found [here](https://gist.github.com/MohamedAlaa/2961058)
* for GPU monitoring in an interactive session, you can use ``nvidia-smi`` or ``nvtop``. This way, you can check whether GPU utilization and memory usage is optimized for the program you run. For CPU monitoring, ``htop`` should be used.
* You can create custom shell commands by modifying your ``.bashrc`` file that is located in your home directory. For example, you might want to create aliases for shell commands that you use often. Just ask ChatGPT what .bashrc is and how you can make use of it :)
