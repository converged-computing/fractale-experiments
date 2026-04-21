# Translation Performance

We are going to prepare different variants of running 5 HPC apps in cloud, across scales for different sizes each, and then ask the agent to transform the commands to Slurm. We will deploy a Slurm cluster in AWS with the same instance types and using Singularity containers to assess the differences.

## Flux Operator Kubernetes

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

Note that these were chosen to fit on one node without OOM. How to orchestrate:

```console
flux proxy local:///mnt/flux/config/run/flux/local bash
export app=lammps-reax
output=./results/$app
mkdir -p $output

for i in $(seq 1 10); do
  echo "Running iteration $i" # (smallest size is 3m 9s)
  flux submit --setattr=user.study_id=$app-1-iter-$i -N1 -n 64 lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns
  # affinity (slows down)?
  flux submit --setattr=user.study_id=$app-1-affinity-iter-$i -o cpu-affinity=per-task -N1 -n 64 lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns
done

for i in $(seq 1 10); do
  echo "Running iteration $i" # (smallest size is 3m 9s)
  flux submit --setattr=user.study_id=$app-2-iter-$i -N2 -n 128 lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns
  flux submit --setattr=user.study_id=$app-3-iter-$i -N3 -n 192 lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns
  # affinity (slows down)?
  flux submit --setattr=user.study_id=$app-2-affinity-iter-$i -o cpu-affinity=per-task -N2 -n 128 lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns
  flux submit --setattr=user.study_id=$app-3-affinity-iter-$i -o cpu-affinity=per-task -N3 -n 192 lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns
done

for i in $(seq 1 10); do
  echo "Running iteration $i" # (smallest size is 3m 9s)
  flux submit --setattr=user.study_id=$app-4-iter-$i -N4 -n 256 lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns
  flux submit --setattr=user.study_id=$app-5-iter-$i -N5 -n 320 lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns
  # affinity (slows down)?
  flux submit --setattr=user.study_id=$app-4-affinity-iter-$i -o cpu-affinity=per-task -N4 -n 256 lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns
  flux submit --setattr=user.study_id=$app-5-affinity-iter-$i -o cpu-affinity=per-task -N5 -n 320 lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns
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
```
On the local machine (here):

```bash
kubectl delete -f ./crd/lammps-reax.yaml
```

### AMG2023

```console
kubectl apply -f ./crd/amg2023.yaml
time kubectl wait --for=condition=ready pod -l job-name=flux-sample --timeout=600s
```

```
export app=amg2023
output=./results/$app
mkdir -p $output

export OMP_NUM_THREADS=1 
export OMPI_MCA_btl_vader_single_copy_mechanism=cma
for i in $(seq 1 10); do
  echo "Running iteration $i"
  flux submit --setattr=user.study_id=$app-1-iter-$i -N1 -n 64 -o pmi=pmi2 amg -problem 2 -n 90 90 90 -P 4 4 4
  flux submit --setattr=user.study_id=$app-1-affinity-iter-$i -o cpu-affinity=per-task -N1 -n 64 -o pmi=pmi2 amg -problem 2 -n 90 90 90 -P 4 4 4
  flux submit --setattr=user.study_id=$app-2-iter-$i -N2 -n 128 -o pmi=pmi2 amg -problem 2 -n 90 90 90 -P 4 8 4
  flux submit --setattr=user.study_id=$app-3-iter-$i -N3 -n 192 -o pmi=pmi2 amg -problem 2 -n 90 90 90 -P 3 8 8
  flux submit --setattr=user.study_id=$app-2-affinity-iter-$i -o cpu-affinity=per-task -N2 -n 128 -o pmi=pmi2 amg -problem 2 -n 90 90 90 -P 4 8 4
  flux submit --setattr=user.study_id=$app-3-affinity-iter-$i -o cpu-affinity=per-task -N3 -n 192 -o pmi=pmi2 amg -problem 2 -n 90 90 90 -P 3 8 8
  flux submit --setattr=user.study_id=$app-4-iter-$i -N4 -n 256 -o pmi=pmi2 amg -problem 2 -n 90 90 90 -P 4 8 8
  flux submit --setattr=user.study_id=$app-5-iter-$i -N5 -n 320 -o pmi=pmi2 amg -problem 2 -n 90 90 90 -P 4 8 10
  flux submit --setattr=user.study_id=$app-4-affinity-iter-$i -o cpu-affinity=per-task -N4 -n 256 -o pmi=pmi2 amg -problem 2 -n 90 90 90 -P 4 8 8
  flux submit --setattr=user.study_id=$app-5-affinity-iter-$i -o cpu-affinity=per-task -N5 -n 320 -o pmi=pmi2 amg -problem 2 -n 90 90 90 -P 4 8 10
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
```

On the local machine (here):

```bash
kubectl delete -f ./crd/amg2023.yaml
```
### Kripke

```bash
export app=kripke
output=./results/$app
mkdir -p $output

for i in $(seq 1 10); do
  flux submit -N 1 --setattr=user.study_id=$app-1-iter-$i -N1 -n 64 kripke --niter 100 --zones 64,64,64 --procs 4,4,4
  flux submit -N 2 --setattr=user.study_id=$app-2-iter-$i -N2 -n 128 kripke --niter 100 --zones 64,64,64 --procs 4,8,4
  flux submit -N 4 --setattr=user.study_id=$app-4-iter-$i -N4 -n 256 kripke --niter 100 --zones 64,64,64 --procs 4,8,8

  flux submit -N 1 --setattr=user.study_id=$app-1-affinity-iter-$i -o cpu-affinity=per-task  -N1 -n 64 kripke --niter 100 --zones 64,64,64 --procs 4,4,4
  flux submit -N 2 --setattr=user.study_id=$app-2-affinity-iter-$i -o cpu-affinity=per-task  -N2 -n 128 kripke --niter 100 --zones 64,64,64 --procs 4,8,4
  flux submit -N 4 --setattr=user.study_id=$app-4-affinity-iter-$i -o cpu-affinity=per-task  -N4 -n 256 kripke --niter 100 --zones 64,64,64 --procs 4,8,8
done
```

### OSU AllReduce

```bash
export app=osu-allreduce
output=./results/$app
mkdir -p $output

for i in $(seq 1 10); do
  echo "Running iteration $i"
  flux submit --setattr=user.study_id=$app-1-iter-$i -N1 -n 64 /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce
  flux submit --setattr=user.study_id=$app-1-affinity-iter-$i -o cpu-affinity=per-task -N1 -n 64 /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce
  flux submit --setattr=user.study_id=$app-2-iter-$i -N2 -n 128 /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce
  flux submit --setattr=user.study_id=$app-3-iter-$i -N3 -n 192 /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce
  flux submit --setattr=user.study_id=$app-2-affinity-iter-$i -o cpu-affinity=per-task -N2 -n 128 /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce
  flux submit --setattr=user.study_id=$app-3-affinity-iter-$i -o cpu-affinity=per-task -N3 -n 192 /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce
  flux submit --setattr=user.study_id=$app-4-iter-$i -N4 -n 256 /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce
  flux submit --setattr=user.study_id=$app-5-iter-$i -N5 -n 320 /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce
  flux submit --setattr=user.study_id=$app-4-affinity-iter-$i -o cpu-affinity=per-task -N4 -n 256 /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce
  flux submit --setattr=user.study_id=$app-5-affinity-iter-$i -o cpu-affinity=per-task -N5 -n 320 /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce
done
```

And OSU Latency

```bash
export app=osu-latency
output=./results/$app
mkdir -p $output

for i in $(seq 1 10); do
  echo "Running iteration $i"
  flux run --setattr=user.study_id=$app-1-run-iter-$i -N2 -n 2 /usr/local/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency
  flux run --setattr=user.study_id=$app-1-run-affinity-iter-$i -o cpu-affinity=per-task -N2 -n 2 /usr/local/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency
done
```

### Cleanup

```bash
eksctl delete cluster --config-file ./nodes-arm.yaml --wait
```

## Translation for Slurm

See setup in [jobspec-agent-conversion](../jobspec-agent-conversion)

```bash
flux start
```

We will need to start the server and add the validation functions and prompt. Start the server with the functions and prompt we need:

```bash
mcpserver start --dual --port 8089
```

In a different terminal, export your API key and the mcp server port.

```bash
export GEMINI_API_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

And then run the experiment.

```bash
flux start
python3 ./run-experiment.py --output ./results/flux-to-slurm
python3 ./run-experiment.py --improve --output ./results/flux-to-slurm-improve
```

Then generate data and results.

```bash
python3 generate_index.py
```

