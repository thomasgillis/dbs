#!/bin/bash
#SBATCH --job-name=dbs
#SBATCH --partition=batch
#SBATCH --nodes=1
#SBATCH --tasks-per-node=8
#SBATCH --mem=240G
#SBATCH --account=examples
#SBATCH --time=2:00:00

module purge
module load GCC/11.3.0
module list

CLUSTER=lucia/mpich_ofi make info
CLUSTER=lucia/mpich_ofi make install
