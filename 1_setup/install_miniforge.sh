# download and install miniforge
cd ~
wget -O Miniforge3.sh "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
MAMBA_ROOT_PREFIX="$HOME/.project/dir.project/conda" bash Miniforge3.sh -b -p "$HOME/.project/dir.project/conda"
rm Miniforge3.sh

# create .condarc file for some basic configurations
cat > "$HOME/.condarc" <<EOF
channels:
  - conda-forge
channel_priority: flexible
EOF

# initialize conda in shell
source "$HOME/.project/dir.project/conda/etc/profile.d/conda.sh"
conda init
