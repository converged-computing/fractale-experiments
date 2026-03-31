# AWS Scaling Study

Let's now give the agent the choice to optimize, telling it that it has a much better selection of instance types. We will first test build and deploy, and then 4 nodes, and then a scaling study.

## 1. Experiment

We are going to build and deploy with separate plans. We will use the same image we used for our first study for a fair comparison.

```bash
# If you are testing:
kind create cluster --config ./kind-config.yaml 
# Experiment
eksctl create cluster --config-file ./eksctl/nodes-arm.yaml
aws eks update-kubeconfig --region us-east-1 --name fractale-arm-cluster
```

For the experiment, on a node (e.g., Google Cloud node) ensure you have fractale, flux-mcp, and hpc-mcp installed.
Start the server:

```bash
mcpserver start --config ./servers/kubernetes-job.yaml --port 8089
```

### LAMMPS

Ask the agent to build lammps. Don't forget to export `GEMINI_API_KEY`

```bash
# We are using the container from the first experiments for consistency

for i in {1..5}; do
  echo "Iteration number $i"
  kubectl get pods -o json > .fractale/pods-{i}.json
  kubectl delete miniclusters --all
  fractale run --database json ./plans/deploy-lammps.yaml
done

# One test with a starting size (suffix with optimize)
fractale run --database json ./plans/optimize-lammps.yaml

# And save nodes for run
kubectl get nodes -o json > nodes.json
```

### AMG2023

```bash
for i in {1..5}; do
  echo "Iteration number $i"
  kubectl get pods -o json > .fractale/pods-{i}.json
  kubectl delete miniclusters --all
  fractale run --database json ./plans/deploy-amg.yaml
done
kubectl get nodes -o json > nodes.json
```

### Kripke

```bash
for i in {1..5}; do
  echo "Iteration number $i"
  kubectl get pods -o json > .fractale/pods-{i}.json
  kubectl delete miniclusters --all
  fractale run --database json ./plans/deploy-kripke.yaml
done
kubectl get nodes -o json > nodes.json
```

### Laghos

Laghos logs were so long we use a function that shorts by way of unique lines.

```bash
mcpserver start --config ./servers/kubernetes-job-laghos.yaml --port 8089
```

```bash
for i in {1..5}; do
  echo "Iteration number $i"
  kubectl get pods -o json > .fractale/pods-{i}.json
  kubectl delete miniclusters --all
  fractale run --database json ./plans/deploy-laghos.yaml
done
kubectl get nodes -o json > nodes.json
```

### OSU All Reduce


```bash
for i in {1..5}; do
  echo "Iteration number $i"
  kubectl get pods -o json > .fractale/pods-{i}.json
  kubectl delete miniclusters --all
  fractale run --database json ./plans/osu-allreduce.yaml
done
kubectl get nodes -o json > nodes.json
```

### OSU Latency

```bash
for i in {1..5}; do
  echo "Iteration number $i"
  kubectl get pods -o json > .fractale/pods-{i}.json
  kubectl delete miniclusters --all
  fractale run --database json ./plans/osu-latency.yaml
done
kubectl get nodes -o json > nodes.json
```


Note that for each run, I did them separately and checked files, then moved into a [results](results) directory named by the application.

## Clean up

```bash
eksctl delete cluster --config-file ./eksctl/nodes-arm.yaml --wait
```
