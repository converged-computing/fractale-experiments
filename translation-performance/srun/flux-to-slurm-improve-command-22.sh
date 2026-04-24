#!/bin/bash
#!/bin/bash
# --nodes=4: Request 4 nodes, same as the original Flux command's -N4.
# --ntasks=256: Request a total of 256 MPI tasks, same as the original -n 256.
# --ntasks-per-node=64: Explicitly distribute the 256 tasks evenly across the 4 nodes.
#                       This ensures a balanced workload.
# --mpi=pmix: Use the PMIx MPI plugin as requested by the user for process management.
# --cpu-bind=cores: Bind each MPI task to a specific CPU core. This improves performance
#                   by preventing the operating system from migrating tasks between cores,
#                   which enhances cache utilization.
# --exclusive: Request exclusive access to the allocated nodes. This prevents other jobs
#              from interfering and ensures that the job has access to all node resources
#              (memory, network bandwidth), leading to more consistent performance.
srun --nodes=4 \
     --ntasks=256 \
     --ntasks-per-node=64 \
     --mpi=pmix \
     --cpu-bind=cores \
     --exclusive \
     kripke --niter 100 --zones 64,64,64 --procs 4,8,8