# Subsystem Scheduling Study

We generate one jobspec per application of interest and run each twice on a fleet
provided by fluxq. There are two cases. The first is "base" and does not have
descriptive subsystems to match, and the second does. We aim to show that having
subsystem (descriptive) metadata improves the match and thus performance.

## Experiment

### Install fluxq

fluxq is one binary with both `serve` and the client subcommands.

```bash
git clone https://github.com/converged-computing/fluxq /tmp/fluxq
pip install -e /tmp/fluxq/client/py[aws]    # fluxq-select
cd /tmp/fluxq && go build -o "$HOME/.local/bin/fluxq" ./cmd/fluxq  # fluxq
```

### Generate the prompts

```bash
cd subsystem-scheduling
python generate_prompts.py
```
```console
wrote 20 prompts to /home/vanessa/Desktop/Code/fractale-experiments/subsystem-scheduling/prompts/ (skipped 1 infra/unusable)
  metric-amg2023               size=4  (28 variants)
  metric-kripke-cpu            size=4  (10 variants)
  metric-kripke-gpu            size=1  (4 variants)
  metric-lammps-cpu            size=3  (21 variants)
  metric-lammps-gpu            size=5  (12 variants)
  metric-linpack-cpu           size=4  (5 variants)
  metric-magma                 size=4  (6 variants)
  metric-minife                size=3  (14 variants)
  metric-mixbench              size=4  (15 variants)
  metric-nek5000               size=3  (14 variants)
  metric-osu-cpu               size=5  (10 variants)
  metric-osu-gpu               size=2  (4 variants)
  metric-quicksilver-cpu       size=5  (8 variants)
  metric-quicksilver-gpu       size=2  (4 variants)
  metric-stream                size=3  (16 variants)
  metrics-quicksilver-cpu      size=2  (1 variants)
  mt-gemm                      size=1  (20 variants)
  multi-gpu-models             size=5  (5 variants)
  osu-benchmark                size=3  (1 variants)
  rdma-infiniband              size=5  (3 variants)
```

This generates the tree under `prompts/` that has one or more variants of an
application with a prompt. We run this on the host, where `eksctl` and `gcloud` are authenticated. 

```bash
# cheapest, and no quota risk
bash ./clusters/create-gke-cpu.sh        

# This would be all at once
PARALLEL=1 bash ./clusters/create-all.sh 

# when you are done, teardown
bash ./clusters/teardown-all.sh
```

Each script creates the cluster, renames the kube-context to the canonical name,
installs the Flux Operator (the **ARM** manifest on the Graviton cluster), and
prints the advertised GPU resource so you can verify the device plugin.

#### Fleet

We create seven single-node-pool (homogeneous) clusters, spanning different dimensions 
to match on, and the goal would be to show the value of descriptive metadata. 

| context | cloud | instance | arch | gpu | net | mem | ~$/hr |
|---|---|---|---|---|---|---|---|
| `sched-gke-cpu` | GKE | e2-standard-4 | amd64 | – | eth | 16 GB | 0.13 |
| `sched-eks-arm-efa` | EKS | hpc7g.4xlarge | **arm64** | – | **EFA** | 128 GB | ~1.7 |
| `sched-eks-gpu-nvidia` | EKS | g5.2xlarge | amd64 | NVIDIA x1 | eth | 32 GB | 1.21 |
| `sched-eks-gpu-nvidia-x4` | EKS | g5.12xlarge | amd64 | NVIDIA x4 | eth | 192 GB | 5.67 |
| `sched-gke-gpu-nvidia` | GKE | g2-standard-8 | amd64 | NVIDIA x1 | eth | 32 GB | 0.85 |
| `sched-eks-gpu-amd` | EKS | g4ad.8xlarge | amd64 | **AMD x2** | eth | 128 GB | 1.73 |
| `sched-eks-cpu-efa-bigmem` | EKS | r7i.8xlarge | amd64 | – | **EFA** | 256 GB | ~2.1 |

Note that this is how I'm rebuilding (and pushing) the fluxq container from the root of the fluxq repository branch.

```bash
docker build -t ghcr.io/converged-computing/fluxq . && docker push ghcr.io/converged-computing/fluxq:latest
```

### Agent Token

The secretary runs inside each MiniCluster, so a credential has to exist in each
cluster rather than on the host. fluxq never sees the token: it records only the
secret name at registration, and the operator mounts it.

```bash
export ANTHROPIC_API_KEY=sk-...

# Note that we used this one, not the top
export AWS_BEARER_TOKEN_BEDROCK=...

# Just needs to be done once
bash ./clusters/create-secret.sh

# Needs to be done each time we create fluxq for the clusters
SECRETARY_SECRET=flux-secretary-token bash ./clusters/register-all.sh
```

### Quick Start

```bash
bash ./clusters/create-gke-cpu.sh
bash ./clusters/create-eks-arm-small.sh
bash ./clusters/make-portable-kubeconfig.sh
bash ./fluxq-container/run.sh
# With secret (or without)
SECRETARY_SECRET=flux-secretary-token bash ./clusters/register-all.sh
bash ./clusters/register-all.sh sched-gke-cpu sched-eks-arm-small
curl -s $FLUXQ/v1/vocabulary | python3 -m json.tool

# Test only
python3 run_experiment.py

# Test run
python3 run_experiment.py --submit --only metric-osu-cpu --timeout 900 --poll 5
kubectl get pods --context sched-gke-cpu
grep FLUXSEC runs/metric-osu-cpu/subsystem.log
```

If you need to clean up:

```bash
docker stop fluxq && docker rm fluxq
kubectl --context sched-gke-cpu delete minicluster --all
```

### Start fluxq

> This is the slow start :)

We need to interact with the kubeconfig from the container in order to dispatch.
However, the kubeconfigs often have commands to update credentials (requiring gcloud
or the aws client on the host). We are testing a strategy to use ServiceAccount tokens
so this is not needed. After you make your clusters:

```bash
bash ./clusters/make-portable-kubeconfig.sh     # -> ../fluxq-container/kubeconfig
grep -c exec ./fluxq-container/kubeconfig       # must be 0
```

Then start fluxq from the published image:

```bash
bash ./fluxq-container/run.sh
export FLUXQ=http://localhost:8080
curl -s $FLUXQ/v1/clusters                       # []
```

The run.sh script is going to run our fluxq container with the kubeconfig mounted, along with a data directory for the sqlite file (probably not necessary). Note that the matcher should be REAL Fluxion. The kubeconfig tokens created to interact with it last for 24 hours, which should not be an issue.

### Register and discover

```bash
# Example one cluster
bash ./clusters/register-all.sh sched-gke-cpu

# All clusters
bash ./clusters/register-all.sh

# Check metadata
curl -s $FLUXQ/v1/clusters | python3 -m json.tool
```

Registration goes through `docker exec` so the kubeconfig path is the one fluxq
sees inside the container:

```bash
fluxq cluster register --name <name> --manager k8s-job \
  --config kubeconfig=/kube/config --config context=<name> --discover
```

Nothing relies on the kubeconfig's *current* context — each cluster is bound to
its own explicit context, so dispatch always reaches the intended cluster no
matter what order things were created in.

Verify:

```bash
curl -s $FLUXQ/v1/clusters | python3 -m json.tool
```

Each cluster should list `subsystems` including `architecture`, `network`, and the
internal `memory-gb`.

Test connection:

```bash
export PATH=/home/vanessa/.local/bin:$PATH
aws sts get-caller-identity
aws bedrock list-inference-profiles --region "us-east-1" --query 'inferenceProfileSummaries[].inferenceProfileId' --output text
```
```bash
python3 -c "import boto3; print(boto3.client('sts').get_caller_identity()['Arn'])"
python3 -c "import boto3,os; c=boto3.client('bedrock', region_name=os.environ.get('AWS_DEFAULT_REGION','us-east-1')); print([p['inferenceProfileId'] for p in c.list_inference_profiles()['inferenceProfileSummaries']])"
```

And test:

```bash
python3 - <<'PY'
from strands import Agent
from strands.models import BedrockModel
m = BedrockModel(model_id="us.anthropic.claude-opus-5",  # paste a real one from step 3
                 region_name="us-east-1")
print(Agent(model=m)("say ok"))
PY
```

### Jobspecs

If you haven't yet:

```bash
pip install -e /tmp/fluxq/client/py[aws]         # fluxq-select
```

A single test case:

```bash
fluxq-select --manifest prompts/metric-lammps-cpu/run.json --model us.anthropic.claude-opus-5
```
```bash
for d in prompts/*/; do fluxq-select --manifest "$d/run.json" --model us.anthropic.claude-opus-5; done
```

The agent reconciles each manifest against the vocabulary: it chooses a container variant, derives the run command from the application, and classifies `network` and `memory` into vocabulary values. `architecture` and `gpu` vendor are stamped from the manifest as facts (from `arch` and `capability.accelerator`. Testing a small set of clusters:

### The actual experiment

```bash
PARALLEL=1 bash ./clusters/create-all.sh          # expect "all 8 contexts present"

# Ensure flux operator installed
for c in $(kubectl config get-contexts -o name | grep '^sched-'); do
  printf "%-28s nodes=%-3s crd=" "$c" "$(kubectl --context $c get nodes --no-headers 2>/dev/null|wc -l)"
  kubectl --context $c get crd miniclusters.flux-framework.org -o name 2>/dev/null || echo MISSING
done

bash ./clusters/make-portable-kubeconfig.sh
bash ./clusters/create-secret.sh    
bash ./clusters/fluxq-container/run.sh
SECRETARY_SECRET=flux-secretary-token ./clusters/register-all.sh
curl -s $FLUXQ/v1/clusters | python3 -m json.tool | grep -c '"id"'
```
