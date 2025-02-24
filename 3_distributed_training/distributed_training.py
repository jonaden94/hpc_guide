import os
import torch
import torch.distributed as dist
from torch.nn.parallel import DistributedDataParallel as DDP
from torch.utils.data import Dataset, DataLoader, DistributedSampler
import torch.nn as nn
import torch.optim as optim
from datetime import datetime
from socket import gethostname

# Simple synthetic dataset
class LinearDataset(Dataset):
    def __init__(self, size=1000, a=2.0, b=5.0, noise_std=0.1):
        self.x = torch.randn(size, 1)
        self.y = a * self.x + b + noise_std * torch.randn(size, 1)

    def __len__(self):
        return len(self.x)

    def __getitem__(self, index):
        return self.x[index], self.y[index]

# Simple linear model
class LinearModel(nn.Module):
    def __init__(self):
        super(LinearModel, self).__init__()
        self.linear = nn.Linear(1, 1)

    def forward(self, x):
        return self.linear(x)

# Training function
def train(local_rank, model, loader, optimizer, epochs):
    model.train()
    for epoch in range(epochs):
        for _, (data, target) in enumerate(loader):
            data, target = data.to(local_rank), target.to(local_rank)
            optimizer.zero_grad()
            output = model(data)
            loss = nn.MSELoss()(output, target)
            loss.backward()
            optimizer.step()
        # print loss for rank 0 process only
        if dist.get_rank() == 0:
            print(f"{datetime.now().replace(microsecond=0)} - Epoch {epoch + 1}, Loss: {loss.item():.3f}")

# Setup for DDP
def setup(rank, world_size):
    # nccl for inter-GPU communication
    dist.init_process_group("nccl", rank=rank, world_size=world_size)

def cleanup():
    dist.destroy_process_group()

def main():
    # training parameters
    epochs = 100
    batch_size = 32
    dataset_size = 1024

    # Get rank (process number) and world size (total number of processes)
    rank = int(os.environ["SLURM_PROCID"])
    world_size = int(os.environ["WORLD_SIZE"])
    gpus_per_node = int(os.environ["SLURM_GPUS_ON_NODE"])
    
    # confirm initialization of rank processes
    print(f"Hello from rank {rank}/{world_size-1} on {gethostname()}", flush=True)
    
    # set device to local rank (gpu number on specific node)
    local_rank = rank - gpus_per_node * (rank // gpus_per_node)
    torch.cuda.set_device(local_rank)

    # Initialize process group (sets up process group and communication between the processes, e.g. for gradient averaging)
    setup(rank, world_size)

    # get dataset and dataloader
    dataset = LinearDataset(size=dataset_size)
    # sampler automatically splits the dataset among the processes. Each process gets a dataset of size dataset_size / world_size
    sampler = DistributedSampler(dataset)
    loader = DataLoader(dataset, batch_size=batch_size, sampler=sampler)

    # Model, optimizer
    model = LinearModel().to(local_rank)
    ddp_model = DDP(model, device_ids=[local_rank])
    optimizer = optim.SGD(ddp_model.parameters(), lr=0.01)

    # Train
    train(local_rank, ddp_model, loader, optimizer, epochs)
    cleanup()

if __name__ == "__main__":
    main()
