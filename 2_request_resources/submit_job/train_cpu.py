import os
import psutil
import numpy as np
from sklearn.ensemble import RandomForestRegressor
from sklearn.datasets import make_regression
from sklearn.model_selection import train_test_split
from multiprocessing import Process

# Worker process to show core usage
def worker(index):
    core_id = psutil.Process().cpu_num()
    print(f"[Worker {index}] PID: {os.getpid()} running on CPU core: {core_id}")

def train_model(n_jobs):
    print("Generating data...")
    X, y = make_regression(n_samples=1000, n_features=20, noise=0.1, random_state=42)
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)

    print(f"Training RandomForestRegressor using {n_jobs} threads...")
    model = RandomForestRegressor(n_estimators=100, n_jobs=n_jobs, random_state=42)
    model.fit(X_train, y_train)

    score = model.score(X_test, y_test)
    print(f"Model R^2 score: {score:.4f}")

if __name__ == "__main__":
    num_cores = int(os.environ.get("SLURM_CPUS_PER_TASK", os.cpu_count()))
    print(f"Using {num_cores} CPU cores...")

    # Spawn worker processes to demonstrate actual core use
    processes = []
    for i in range(num_cores):
        p = Process(target=worker, args=(i,))
        processes.append(p)
        p.start()
    for p in processes:
        p.join()

    # Train the model using all available cores
    train_model(n_jobs=num_cores)
