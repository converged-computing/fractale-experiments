# AWS Autoscaling

Let's now give the agent the choice to optimize, telling it that it has a much better selection of instance types. We will first test build and deploy, and then 4 nodes, and then a scaling study.

## 1. Single Node

We are going to build and deploy with separate plans. We will use the same image we used for our first study for a fair comparison.

```bash
eksctl create cluster --config-file ./eksctl/single-node-arm.yaml 
aws eks update-kubeconfig --region us-east-2 --name fractale-cluster
```

On a node (e.g., Google Cloud node) ensure you have fractale, flux-mcp, and hpc-mcp installed.
Start the server:

```bash
mcpserver start --config ./servers/kubernetes-job.yaml
```

Ask the agent to build lammps. Don't forget to export `GEMINI_API_KEY`

```bash
# Note I instead opted to use the container from the first experiments for consistency
# fractale run ./plans/build-lammps.yaml
# fractale prompt Build and push lammps docker.io/vanessa/fractale-test:lammps and discover the Kubernetes cluster. Install the Flux Operator and deploy the lammps container to run as a MiniCluster. Get the logs and parse the figure of merit.

for i in {1..8}; do
  echo "Iteration number $i"
  kubectl delete miniclusters --all
  fractale run ./deploy-lammps.yaml
done
```

## 2. 4 Node Optimize

TODO next I will add multi-nodes and autoscaling. But first I need to look over the logs carefully and better tweak the expert.


