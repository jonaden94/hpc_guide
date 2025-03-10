# create symbolic links to data storages
cd ~
mkdir $HOME/scratch
ln -s /mnt/lustre-grete/usr/$USER $HOME/scratch/scratch_grete
ln -s /mnt/lustre-emmy-ssd/usr/$USER $HOME/scratch/scratch_emmy

# download and install miniforge to scratch_emmy
wget -O Miniforge3.sh "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3.sh -b -p "$HOME/scratch/scratch_emmy/conda"
rm Miniforge3.sh

# initialize conda in shell
source $HOME/scratch/scratch_emmy/conda/etc/profile.d/conda.sh
conda init
