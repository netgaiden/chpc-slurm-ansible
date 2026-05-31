#!/bin/bash
# =============================================================================
# Graceful Shutdown for CHPC-style Slurm Cluster
# Run this from your Mac (inside the chpc-slurm-ansible folder)
# =============================================================================

set -euo pipefail

echo "=== Starting graceful shutdown of CHPC Slurm cluster ==="

# 1. Drain compute nodes (prevent new jobs)
echo "→ Draining compute nodes..."
ssh rocky@login01 'sudo scontrol update NodeName=cn[01-02] State=DRAIN Reason="graceful shutdown"'

# 2. Cancel any running or pending jobs
echo "→ Cancelling all jobs..."
ssh rocky@login01 'scancel --all' || true

# 3. Stop slurmd on compute nodes
echo "→ Stopping slurmd on compute nodes..."
ssh rocky@cn01 'sudo systemctl stop slurmd' || true
ssh rocky@cn02 'sudo systemctl stop slurmd' || true

# 4. Unmount NFS /home on compute nodes (this prevents hang on shutdown)
echo "→ Unmounting NFS /home on compute nodes..."
ssh rocky@cn01 'sudo umount -f /home' || true
ssh rocky@cn02 'sudo umount -f /home' || true

# 5. Stop services on head node
echo "→ Stopping services on login01..."
ssh rocky@login01 'sudo systemctl stop slurmctld munge' || true

echo "=== Cluster is now safely drained and stopped ==="
echo "You can now safely Power Off the VMs in VMware Fusion."