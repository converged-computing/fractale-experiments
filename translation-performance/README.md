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


## Slurm Experiments

### LAMMPS

```bash
mkdir -p ./manual
for i in $(seq 2 10); do
  echo "Running iteration $i"
  srun --mpi=pmix --nodes=5 --ntasks=320 --ntasks-per-node=64 --cpus-per-task=1 lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns 2>&1 | tee ./manual/lammps-5-nodes-${i}.out
  srun --mpi=pmix --nodes=5 --ntasks=320 --ntasks-per-node=64 --cpus-per-task=1 --cpu-bind=cores lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns 2>&1 | tee ./manual/lammps-5-nodes-affinity-${i}.out
done

for n in {1..4}; do
  tasks=$((n * 64))
  for mode in "standard" "affinity"; do
    # Configure flags based on mode
    bind_flag=""
    suffix=""
    if [ "$mode" == "affinity" ]; then
      bind_flag="--cpu-bind=cores"
      suffix="-affinity"
    fi

    for i in {1..10}; do
      log_file="./manual/lammps-${n}-nodes${suffix}-${i}.out"
      echo "Starting: ${n} nodes, ${mode} mode, iteration ${i}"      
      # 1. Print Start Timestamp to log and screen
      echo "START_TIMESTAMP: $(date '+%Y-%m-%d %H:%M:%S')" | tee "$log_file"      
      srun --mpi=pmix --nodes=${n} --ntasks=${tasks} --ntasks-per-node=64 --cpus-per-task=1 ${bind_flag} lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns 2>&1 | tee -a "$log_file"
      # 3. Print End Timestamp to log and screen
      echo "END_TIMESTAMP: $(date '+%Y-%m-%d %H:%M:%S')" | tee -a "$log_file"      
      echo "Finished iteration ${i}. Log saved to ${log_file}"
      echo "------------------------------------------------"
    done
  done
done
```

For other sizes, use the script to generate batch files.

```bash

bash ./script/generate_lammps.sh
mkdir -p ./results
echo "job_id,script_path" > ./results/lammps_submission_log.csv
for f in ./scripts/*.sbatch; do 
    jid=$(sbatch --parsable "$f")
    echo "$jid,$f" >> ./results/lammps_submission_log.csv
    echo "Submitted $f as Job $jid"
done
```

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
python3 ./run-experiment.py --output ./results/convert/flux-to-slurm
python3 ./run-experiment.py --improve --output ./results/convert/flux-to-slurm-improve
python3 ./run-experiment.py --with-singularity --output ./results/convert/flux-to-slurm-singularity
python3 ./run-experiment.py --with-singularity --improve --output ./results/convert/flux-to-slurm-singularity-improve

# These are ultimately those used for experiment
python3 ./run-experiment.py --slurm-operator --output ./results/convert/flux-to-slurm
python3 ./run-experiment.py --slurm-operator --improve --output ./results/convert/flux-to-slurm-improve
```

Then generate data and results.

```bash
python3 generate_index.py
python3 extract_slurm_jobs.py
```

## Slurm Jobs

Deploying Slurm on AWS PCS or PC was terrible, so I updated our slurm operator to do it. Create the cluster, install the operator.

```bash
eksctl create cluster --config-file ./nodes-arm.yaml 
aws eks update-kubeconfig --region us-east-1 --name fractale-arm-cluster

# Install jobset
kubectl apply --server-side -f https://github.com/kubernetes-sigs/jobset/releases/download/v0.11.1/manifests.yaml

# Slurm Operator
kubectl apply -f crd/slurm-operator-arm.yaml

# What can we customize?
kubectl explain slurm
```

### Experiments

Create each experiment, shell into the -s node, which is the login. We will need to clone the sbatch submission scripts.

```bash
kubectl apply -f crd/lammps-reax-slurm.yaml

git clone -b translation-experiments --depth 1 https://github.com/converged-computing/fractale-experiments
# get the slurm experiments for lammps
mkdir -p ./sbatch
grep -rl "lmp" ./fractale-experiments/translation-performance/sbatch | xargs -I {} cp {} ./sbatch
bash submit_all.sh lammps
```

Here is a script to submit all jobs:

```bash
#!/bin/bash

# Configuration
APP=${1}
SCRIPT_DIR="./sbatch"
LOG_FILE="${APP}_log.csv"
echo "job_id,filename" > "$LOG_FILE"
if [ ! -d "$SCRIPT_DIR" ]; then
    echo "Error: Directory $SCRIPT_DIR does not exist."
    exit 1
fi

for file in "$SCRIPT_DIR"/*.sbatch; do    
    [ -e "$file" ] || continue

    echo "Submitting $file..."
    # Submit job and capture the ID
    # --parsable returns just the number
    JOB_ID=$(sbatch --parsable "$file")
    if [ $? -eq 0 ]; then
        # Record the Job ID and the filename to our log
        echo "${JOB_ID},${file}" >> "$LOG_FILE"
        echo "Successfully submitted: Job ID ${JOB_ID}"
    else
        echo "Failed to submit: $file"
        echo "FAILED,${file}" >> "$LOG_FILE"
    fi
done
echo "Done! Mapping saved to $LOG_FILE"
```
