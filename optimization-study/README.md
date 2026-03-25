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
mcpserver start --config ./servers/kubernetes-job.yaml
```

Ask the agent to build lammps. Don't forget to export `GEMINI_API_KEY`

```bash
# We are using the container from the first experiments for consistency

for i in {1..5}; do
  echo "Iteration number $i"
  kubectl delete miniclusters --all
  fractale run --database json ./plans/deploy-lammps.yaml
done
```

## Clean up

```bash
eksctl delete cluster --config-file ./eksctl/nodes-arm.yaml --wait
```
