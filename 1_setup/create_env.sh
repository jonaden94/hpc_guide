ENV_NAME='torch_env'
eval "$(mamba shell hook --shell bash)"
mamba env remove -n $ENV_NAME -y
mamba create -n $ENV_NAME python=3.10 -y
mamba activate $ENV_NAME

# install environment
mamba install pytorch==2.0.0 torchvision==0.15.0 torchaudio==2.0.0 pytorch-cuda=11.8 -c pytorch -c nvidia -y
mamba install nvidia/label/cuda-11.8.0::cuda-toolkit -y # fixes some weird cudnn laoding error (might be unnecessary on other systems)
mamba install mkl=2024.0.0 -y # fixes some pytorch bug
pip install numpy==1.26.4
pip install jupyter
