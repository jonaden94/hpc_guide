import os
from sklearn.datasets import make_classification
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import log_loss

# Get SLURM environment variables
task_id = int(os.environ.get("SLURM_PROCID", 0)) # n unique tasks are spawned where "n" is as defined in the SLURM script
n_threads = len(os.sched_getaffinity(0)) # this should be equivalent to the "c" argument in the SLURM script
node = os.uname().nodename # each of the n unique tasks reside on a single node. They way they are allocated among the requested number of nodes depends on space available on the assigned nodes. The total number of nodes is defined by the "N" argument in the SLURM script.

# Define list of possible max_depth values and select one based on task_id
max_depths = list(range(2, 2000))
max_depth = max_depths[task_id]

# Dummy dataset
X, y = make_classification(n_samples=2000, n_features=20, random_state=42)

# Fit model with n_jobs = n_threads
clf = RandomForestClassifier(max_depth=max_depth, n_jobs=n_threads, random_state=42)
clf.fit(X, y)

# compute train loss
y_proba = clf.predict_proba(X)
train_loss = log_loss(y, y_proba)

# print results
print(f"[Task {task_id}] running on node {node}. Using {n_threads} threads to fit random forest classifier with maximum depth of {max_depth}. Resulting train loss={train_loss:.4f}", flush=True)
