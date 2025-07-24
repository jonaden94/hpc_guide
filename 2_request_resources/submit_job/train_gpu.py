import torch
import torch.nn as nn
import torch.optim as optim

# Create dummy data and put on GPU
x = torch.randn(100, 10).cuda()
y = torch.randn(100, 1).cuda()

# Model
def model(): return nn.Linear(10, 1)

# Training loop
def train():
    net = model().cuda() # put model on GPU
    print(f"Model parameters are on {next(net.parameters()).device}", flush=True)
    print(f"Training data are on {x.device}", flush=True)
    
    loss_fn = nn.MSELoss()
    opt = optim.SGD(net.parameters(), lr=0.01)
    
    print("Start Training...", flush=True)
    for epoch in range(10):
        opt.zero_grad()
        loss = loss_fn(net(x), y)
        loss.backward()
        opt.step()
        print(f"Epoch {epoch+1}: Loss = {loss.item():.4f}", flush=True)

train()