# chpc-slurm-ansible

Ansible automation for a realistic **University of Utah CHPC-style** Rocky 9 Slurm mini-cluster.

Built as practice for the **CHPC Systems Administrator** role.

## Features

- 1 head node (`login01`) + 2 compute nodes (`cn01`, `cn02`)
- Shared `/home` via NFS
- Munge authentication (proper key distribution)
- Slurm 22.05 with realistic `slurm.conf` (CHPC-style node naming and partitions)
- Idempotent playbooks
- Works on Rocky 9 (exactly what CHPC runs)

## Quick Start

```bash
# From your Mac
ansible-playbook -i inventory.yml playbooks/site.yml