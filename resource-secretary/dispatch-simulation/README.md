# Dispatch Simulations

For dispatch, we are primarily interested in the extent to which the agent can successfully receive a textual request for work and transform it into the appropriate environment to run. We will first do an experiment in a single, 5 node cluster using the Flux Operator and hpc7g nodes for AWS, using a large problem size.

In this work, we are interested in the step of dispatching work to a cluster, which includes the steps of job translation (converting a prompt or job spec from another manager to work on a specific cluster) and job submission. The first requires a conversion that might lose information, and the second requires an agent to know how to start with the converted spec, submit, monitor, and return a response.

## Baseline

We can establish a baseline for running LAMMPS on 5 nodes.

### Setup

Create the cluster and install the Flux Operator:

```bash
eksctl create cluster --config-file ./nodes-arm.yaml
aws eks update-kubeconfig --region us-east-1 --name fractale-arm-cluster
kubectl apply -f https://raw.githubusercontent.com/flux-framework/flux-operator/refs/heads/main/examples/dist/flux-operator-arm.yaml
kubectl get nodes -o json > nodes.json
```

This is how to shell in, write a result saving file.

```bash
kubectl apply -f ./crd/lammps-reax.yaml
time kubectl wait --for=condition=ready pod -l job-name=flux-sample --timeout=600s
```
```bash
# shell in and...
flux proxy local:///mnt/flux/config/run/flux/local bash
```

### LAMMPS

How to orchestrate:

```console
flux proxy local:///mnt/flux/config/run/flux/local bash
oras login ghcr.io --username vsoch
export app=lammps-reax
output=./results/$app
mkdir -p $output

for i in $(seq 1 10); do
  echo "Running iteration $i"
  # 2m30s
  time flux run --setattr=user.study_id=$app-5-iter-$i -N5 -n 320 lmp -v x 32 -v y 32 -v z 16 -in in.reaxff.hns
  # testing -nocite (same but should be different output)
  time flux run --setattr=user.study_id=$app-5-nocite-iter-$i -N5 -n 320 lmp -v x 32 -v y 32 -v z 16 -in in.reaxff.hns -nocite
  # affinity (slows down)
  # Note that this is actually ~2 SLOWER. I think because tasks can't migrate anyway on hpc7g, so the Flux shell (and applying masks) probably adds latency.
  time flux run --setattr=user.study_id=$app-5-cpu-affinity-iter-$i -N5 -n 320 -o cpu-affinity=per-task lmp -v x 32 -v y 32 -v z 16 -in in.reaxff.hns
done

for jobid in $(flux jobs -a --json | jq -r .jobs[].id)
  do
    # Get the job study id
    study_id=$(flux job info $jobid jobspec | jq -r ".attributes.user.study_id")
    echo "Parsing jobid ${jobid} and study id ${study_id}"
    flux job attach $jobid &> $output/${study_id}-${jobid}.out 
    echo "START OF JOBSPEC" >> $output/${study_id}-${jobid}.out 
    flux job info $jobid jobspec >> $output/${study_id}-${jobid}.out 
    echo "START OF EVENTLOG" >> $output/${study_id}-${jobid}.out 
    flux job info $jobid guest.exec.eventlog >> $output/${study_id}-${jobid}.out
done

oras push ghcr.io/converged-computing/fractale-experiments/dispatch:eks-efa-cpu-5-$app $output
```
On the local machine (here):

```bash
oras pull ghcr.io/converged-computing/fractale-experiments/dispatch:eks-efa-cpu-5-lammps-reax
kubectl get pods -o json > results/lammps-reax/pods.json
kubectl delete -f ./crd/lammps-reax.yaml
```

### Testing Cluster 

Testing the experiment setup

```bash
eksctl create cluster --config-file ./nodes-test-arm.yaml 
aws eks update-kubeconfig --region us-east-1 --name fractale-arm-cluster
kubectl apply -f https://raw.githubusercontent.com/flux-framework/flux-operator/refs/heads/main/examples/dist/flux-operator-arm.yaml
kubectl apply -f ./crd/minicluster-lammps.yaml
```

If you want to connect to Flux inside:

```bash
# shell inside pod
kubectl exec -it <pod> -- bash
. /mnt/flux/flux-view.sh
unset LD_LIBRARY_PATH
flux proxy $fluxsocket bash
```

### Runs

Let's run MANY small sized problems, first on one node.

```bash
for i in $(seq 1 10); do
  echo "Running iteration $i"
  python3 test-dispatch.py -x 2 -y 2 -z 2 --nodes 1 --tasks 64 --outdir ./dispatch-results/$i
done
```

### One Node LAMMPS 

This can be run in the same one node environment as above.

```console
flux proxy local:///mnt/flux/config/run/flux/local bash
oras login ghcr.io --username vsoch
export app=lammps-reax
output=./results/$app
mkdir -p $output

for i in $(seq 1 10); do
  echo "Running iteration $i"
  time flux run --setattr=user.study_id=$app-1-iter-$i -N1 -n 64 lmp -v x 2 -v y 2 -v z 2 -in in.reaxff.hns
  time flux run --setattr=user.study_id=$app-1-nocite-iter-$i -N1 -n 64 lmp -v x 2 -v y 2 -v z 2 -in in.reaxff.hns -nocite
  time flux run --setattr=user.study_id=$app-1-cpu-affinity-iter-$i -N1 -n 64 -o cpu-affinity=per-task lmp -v x 2 -v y 2 -v z 2 -in in.reaxff.hns
done

for jobid in $(flux jobs -a --json | jq -r .jobs[].id)
  do
    # Get the job study id
    study_id=$(flux job info $jobid jobspec | jq -r ".attributes.user.study_id")
    echo "Parsing jobid ${jobid} and study id ${study_id}"
    flux job attach $jobid &> $output/${study_id}-${jobid}.out 
    echo "START OF JOBSPEC" >> $output/${study_id}-${jobid}.out 
    flux job info $jobid jobspec >> $output/${study_id}-${jobid}.out 
    echo "START OF EVENTLOG" >> $output/${study_id}-${jobid}.out 
    flux job info $jobid guest.exec.eventlog >> $output/${study_id}-${jobid}.out
done

oras push ghcr.io/converged-computing/fractale-experiments/dispatch:eks-efa-cpu-1-$app $output
```

On the local machine (in results/lammps-reax):

```bash
kubectl cp lammps-0-nthbp:/opt/lammps-reax/results/lammps-reax ./
kubectl delete -f ./crd/lammps-reax.yaml
```

### 5 Node Cluster 

```bash
eksctl create cluster --config-file ./nodes-arm.yaml 
aws eks update-kubeconfig --region us-east-1 --name fractale-arm-cluster
kubectl apply -f https://raw.githubusercontent.com/flux-framework/flux-operator/refs/heads/main/examples/dist/flux-operator-arm.yaml
kubectl apply -f ./crd/minicluster-lammps.yaml
```

If you want to connect to Flux inside:

```bash
# shell inside pod
kubectl exec -it <pod> -- bash
. /mnt/flux/flux-view.sh
unset LD_LIBRARY_PATH
flux proxy $fluxsocket bash
```

### Runs

Dependencies

```bash
pip install fastmcp resource-secretary --break-system-packages
```

```bash
# base case
python3 test-dispatch.py -x 32 -y 32 -z 16 --nodes 5 --tasks 320 --outdir ./dispatch-results/size-5 --max-duration 3m

# ask agent to validate lammps args. We also increase number of max attempts to allow for retry
# Note that we ran about ~300 and hit this error:
https://docs.cloud.google.com/vertex-ai/generative-ai/docs/provisioned-throughput/error-code-429
python3 test-dispatch.py -x 32 -y 32 -z 16 --nodes 5 --tasks 320 --outdir ./dispatch-results/size-5-validate --max-duration 3m --with-validate "You MUST have parameters x,y,z in the command, and you MUST use a tool to validate your lammps parameters before submit."
```

### AMG2023

**not done yet**

```console
kubectl apply -f ./crd/amg2023.yaml
time kubectl wait --for=condition=ready pod -l job-name=flux-sample --timeout=600s
```
Install ORAS into this one.

```bash
VERSION="1.3.0"
curl -LO "https://github.com/oras-project/oras/releases/download/v1.3.0/oras_1.3.0_linux_arm64.tar.gz"
mkdir -p oras-install/
tar -zxf oras_${VERSION}_*.tar.gz -C oras-install/
mv oras-install/oras /usr/local/bin/
rm -rf oras_${VERSION}_*.tar.gz oras-install/
```
```
export PATH=$PATH:/mnt/flux/view/bin 
. /mnt/flux/flux-view.sh
flux proxy local:///mnt/flux/config/run/flux/local bash
oras login ghcr.io --username vsoch
export app=amg2023
output=./results/$app
mkdir -p $output

export MP_NUM_THREADS=1 
export OMPI_MCA_btl_vader_single_copy_mechanism=cma
for i in $(seq 1 10); do
  echo "Running iteration $i"
  # 2m30s
  time flux run --setattr=user.study_id=$app-5-iter-$i -N5 -n 320 -o pmi=pmi2 amg -problem 2 -n 2 2 2 -P 8 8 5
  # testing -nocite (same but should be different output)
  time flux run --setattr=user.study_id=$app-5-nocite-iter-$i -N5 -n 320 lmp -v x 32 -v y 32 -v z 16 -in in.reaxff.hns -nocite
  # affinity (slows down)
  # Note that this is actually ~2 SLOWER. I think because tasks can't migrate anyway on hpc7g, so the Flux shell (and applying masks) probably adds latency.
  time flux run --setattr=user.study_id=$app-5-cpu-affinity-iter-$i -N5 -n 320 -o cpu-affinity=per-task lmp -v x 32 -v y 32 -v z 16 -in in.reaxff.hns
done

for jobid in $(flux jobs -a --json | jq -r .jobs[].id)
  do
    # Get the job study id
    study_id=$(flux job info $jobid jobspec | jq -r ".attributes.user.study_id")
    echo "Parsing jobid ${jobid} and study id ${study_id}"
    flux job attach $jobid &> $output/${study_id}-${jobid}.out 
    echo "START OF JOBSPEC" >> $output/${study_id}-${jobid}.out 
    flux job info $jobid jobspec >> $output/${study_id}-${jobid}.out 
    echo "START OF EVENTLOG" >> $output/${study_id}-${jobid}.out 
    flux job info $jobid guest.exec.eventlog >> $output/${study_id}-${jobid}.out
done

oras push ghcr.io/converged-computing/fractale-experiments/dispatch:eks-efa-cpu-5-$app $output
```

On the local machine (here):

```bash
oras pull ghcr.io/converged-computing/fractale-experiments/dispatch:eks-efa-cpu-5-lammps-reax
kubectl get pods -o json > results/lammps-reax/pods.json
kubectl delete -f ./crd/lammps-reax.yaml
```

### Cleanup

```bash
eksctl delete cluster --config-file ./nodes-arm.yaml --wait
```
