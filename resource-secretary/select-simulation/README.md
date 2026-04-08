# Selection experiments

We need to have done negotiation experiments. Then, targeting an output data directory:

```bash
# Note that "jobs" needs to be in data-dir
for i in {1..10}
  do
  python run_analysis.py --data-dir ../negotiate-simulation/data/1 --iter $i --outdir ./results/experiment
done
```

These were testing. First, without state.

```bash
for i in {0..10}
  do
  python run_analysis.py --data-dir ../negotiate-simulation/data/1 --iter $i --outdir ./results/without-state --without-state
done
```

And adding truth.

```bash
for i in {0..10}
  do
  python run_analysis.py --data-dir ../negotiate-simulation/data/1 --iter $i --outdir ./results/agentic --with-truth
done
```

Without truth, but reset depth

```bash
for i in {0..10}
  do
  python run_analysis.py --data-dir ../negotiate-simulation/data/1 --iter $i --outdir ./results/reset-depth --reset-queue
done
```


Plot results!

```bash
python plot_results.py ./results/reset-depth/ --output ./results/images/test-reset-depth
python plot_results.py ./results/experiment  --output ./results/images/experiment
```
