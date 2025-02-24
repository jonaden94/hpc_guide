ENV_NAME='torch_env'
conda env remove -n $ENV_NAME -y
conda create -n $ENV_NAME python=3.10 -y
conda activate $ENV_NAME

# install environment
module load cuda/11.8 # make cluster cuda version compatible with the installed pytorch version
conda install pytorch==2.0.0 torchvision==0.15.0 torchaudio==2.0.0 pytorch-cuda=11.8 -c pytorch -c nvidia -y
conda install nvidia/label/cuda-11.8.0::cuda-toolkit -y # fixes some weird cudnn laoding error (might be unnecessary on other systems)
conda install mkl=2024.0.0 -y # fixes some pytorch bug
pip install numpy==1.26.4
