# create symbolic links to data storages
ln -s /scratch/users/$USER $HOME/scratch

# download and install miniforge to scratch_emmy
wget -O Miniforge3.sh "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3.sh -b -p "$HOME/scratch/conda"
rm Miniforge3.sh

# initialize conda in shell
source $HOME/scratch/conda/etc/profile.d/conda.sh
conda init
