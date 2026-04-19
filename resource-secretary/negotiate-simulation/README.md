# Negotiation Simulation

On a single node. Bring up the hub. Note that we are starting in batch so requests will be done to workers in groups of 5.

## Testing

```bash
mcpserver start --hub --hub-secret potato --serial
```

We can mock a worker by adding `--mock` and we will get a distribution of 40/40/20 for cloud, hpc, standalone. Let's start testing 5 mock workers. Note that `--verbose` ensures we return tool calls.

```bash
for i in {1..3}
do
   PORT=$((1000 + i))   
   mcpserver start --join http://0.0.0.0:8000 --port ${PORT} --mock --worker-id ${i} --join-secret potato --verbose &   
   echo "Launched Worker $i on port $PORT"
done
```

Kill all background jobs:

```bash
kill $(jobs -p)
```

## Make requests.

We can do a satisfy request that will do negotiation (and not go into selection or dispatch).

```bash
resource-ask satisfy "I need <resources, constraints>"
```


## Experiment

### Hub

```bash
mcpserver start --hub --hub-secret potato --serial
```

### Workers

```bash
for i in {1..100}
do
   PORT=$((6000 + i))   
   mcpserver start --join http://0.0.0.0:8000 --port ${PORT} --mock --worker-id ${i} --join-secret potato --verbose &  
   echo "Launched Worker $i on port $PORT"
done
```

### Export Truth

Let's export the truth.
In another terminal, you can request to export the simulation "truth" - the metadata generated for the providers chosen for the archetype.

```bash
# Export Timestamp: 1775518098.673377  Archetypes: {'hpc': 44, 'cloud': 32, 'standalone': 24}
resource-ask export --output ground-truth.json
```

When you are done:

```bash
kill $(jobs -p)
```

### Run it!

Note that I chose to do this in a more "restartable" way, meaning starting all the workers, exporting their prompts, and then asking to run one prompt (based on id) across all workers. That way, if there was a bad state I could exit, and then try again at the last prompt not done.

```bash
# Generate the prompts
mkdir -p negotiate-results/jobs

# Run the tests
for i in {0..9}; do
    START=$((i * 10))
    OUTFILE="./negotiate-results/jobs/batch-${i}.json"    
    python3 test-negotiation.py --count 10 --generate-only --start "$START" --save-generation "$OUTFILE"    
    time python3 test-negotiation.py --tests "$OUTFILE"
done
```

### Analysis

```bash
# I ran this in VSCode
pip install pandas seaborn matplotlib rich scipy --break-system-packages
python3 run_analysis.py
```

## Run Experiment

To run the full experiment. If you want to load a previously generated test suite:

```bash
python3 test-negotiation.py --count 1 --tests ./test-suite.json
```
