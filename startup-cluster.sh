#!/bin/bash
# =============================================================================
# Graceful Startup for CHPC-style Slurm Cluster
# Run this from your Mac after powering on the VMs
# =============================================================================

set -euo pipefail

echo "=== Starting CHPC Slurm cluster (head node first) ==="

# 1. Start services on head node (login01)
echo "→ Starting munge and slurmctld on login01..."
ssh rocky@login01 'sudo systemctl start munge slurmctld'

# 2. Start munge on compute nodes
echo "→ Starting munge on compute nodes..."
ssh rocky@cn01 'sudo systemctl start munge'
ssh rocky@cn02 'sudo systemctl start munge'

# 3. Start slurmd on compute nodes
echo "→ Starting slurmd on compute nodes..."
ssh rocky@cn01 'sudo systemctl start slurmd'
ssh rocky@cn02 'sudo systemctl start slurmd'

# 4. Bring nodes online in Slurm
echo "→ Bringing nodes to IDLE state..."
ssh rocky@login01 'sudo scontrol update NodeName=cn[01-02] State=IDLE Reason=clear'

# 5. Final status check
echo "=== Cluster startup complete ==="
ssh rocky@login01 'sinfo'
ssh rocky@login01 'squeue'

echo ""
echo "Cluster should now be ready. You can run jobs with sbatch."