# Subsystem Scheduling Study

We are going to generate one jobspec per application of interest and run each twice on a fleet provided by fluxq.
There are two cases. The first is "base" and does not have descriptive subsystems to match, and the second does. We aim to show that having subsystem (descriptive) metadata improves the match and thus performance.

## Setup

```bash
# The client is here
git clone https://github.com/converged-computing/fluxq /tmp/fluxq
pip install -e /tmp/fluxq/client/py[aws] --break-system-packages
# now `fluxq-select` is on PATH
```

The random size is drawn once per app and frozen into the prompt, so the base and
subsystem runs use the identical jobspec — the paired diff is the measurement.

Infrastructure containers (flux, base toolkit images) are dropped, and the prompt
instructs the agent to skip anything that isn't a real HPC/AI-ML application.
