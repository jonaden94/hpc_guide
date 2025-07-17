# Prelminaries
* This repository should be cloned into a folder named "repos" in your home directory.
* It is further assumed that you use a linux shell, e.g. ``bash``. You can choose which shell is used on the SCC/NHR on your AcademicCloud profile under ``OTHER``.
* The shell commands provided in this guide assume that you have a shell opened with the root directory of this repository as the working directory.

# 1. Creating symlinks to scratch + installing miniforge

* miniforge is a minimal distribution of conda that allows to structure packages, for example python packages, into environments.
* You can install miniforge in your home directory, but I would not recommend this since disc space is quite limited there. 
* Instead, I would recommend to use the project data store, which is much larger. Details on different data stores can be found [here](https://docs.hpc.gwdg.de/how_to_use/the_storage_systems/index.html)
* You can create symbolic links to different

Both clusters provide specialized data storages (called "scratch"), which have a larger capacity and are mounted there. It is recommended to create symbolic links to scratch in your home directory. You can then store larger data there and conveniently access it via the GUI of VS Code. 
* Running the following shell script will automatically set up symbolic links to scratch at ``~/scratch`` and install miniforge there:
```
source 1_setup/install_miniforge_nhr.sh # run if on NHR
source 1_setup/install_miniforge_scc.sh # run if on SCC
```
* The installation of miniforge might take a while and you might need to reopen your shell afterwards.
* If you are on the NHR, you will notice that there are two scratch folders. More details about when to use which storage can be found [here](https://docs.hpc.gwdg.de/how_to_use/the_storage_systems/data_stores/scratch_work/index.html). Roughly speaking, the connection of scratch emmy to GPU nodes is a little slower, but it has less capacity issues. So it is preferred to use scratch emmy in most cases. Both storages are limited in capacity and are meant for active data only. They also do not have a backup!

# 2. Creating conda environment with Pytorch
* Once miniforge has been installed and initialized, you can create your own conda environments. The examples in this guide only require pytorch to be installed. If conda is activated, you can install an environment containing pytorch by running the following command:
```
source 1_setup/create_env.sh
```
* The creation of the environment might take a while since Pytorch is quite a big package.
