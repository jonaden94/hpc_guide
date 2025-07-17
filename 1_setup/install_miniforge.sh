# download and install miniforge
cd ~
wget -O Miniforge3.sh "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3.sh -b -p "$HOME/.project/dir.project/conda"
rm Miniforge3.sh

# initialize mamba in shell
$HOME/.project/dir.project/conda/bin/mamba shell init bash

# permanently define conda as an alias for mamba since conda is more established as a command but mamba is much faster
echo 'alias conda="mamba"' >> ~/.bashrc
