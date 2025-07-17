# Prelminaries
* This repository should be cloned into a folder named "repos" in your home directory.
* It is further assumed that you use a linux shell, e.g. ``bash``. You can choose which shell is used on the SCC/NHR on your AcademicCloud profile under ``OTHER``.
* The shell commands provided in this guide assume that you have a shell opened with the root directory of this repository as the working directory.

# 1. Making shell prompt nicer
* While not absolutely necessary, it is much nicer to have a colorful shell prompt to make it easily distinguishable to the commands you run.
* This and many other shell-related things can be modified by adapting your ``.bashrc`` file in your home directory
* Run the following shell script for some basic visual enhancements of your shell prompt:
```
source 1_setup/modify_bashrc.sh
```
* When you open a new shell session now, you should see that the visual appearance of your shell prompt changed (to the better).

# 2. Installing miniforge

* miniforge is a minimal distribution of conda that allows to structure packages, for example python packages, into environments.
* Although it is possible to install miniforge in your home directory, this might lead to problems since disc space is quite limited there.
* Apart from your home directory, there are various other data stores for different purposes. A description of those data stores can be found [here](https://docs.hpc.gwdg.de/how_to_use/the_storage_systems/index.html).
* Those data stores that are project specific (i.e. those that all members of a project can access) are automatically linked to the home directory at ``.project``.
* A good location for miniforge is the project-specific data store on the VAST system, which is linked to your home directory as ``.project/dir.project``.
* Running the following shell script installs miniforge in the project-specific data store:
```
source 1_setup/install_miniforge.sh
```
* The installation of miniforge might take a while and you might need to re-open your shell afterwards.

# 2. Creating conda environment with Pytorch
* Once miniforge has been installed and initialized, you can create your own conda environments. The examples in this guide only require pytorch to be installed. If conda is activated, you can install an environment containing pytorch by running the following command:
```
source 1_setup/create_env.sh
```
* The creation of the environment might take a while since Pytorch is quite a big package.
