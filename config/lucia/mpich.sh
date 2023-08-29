#!/bin/bash
#SBATCH --job-name=dbs-mpich
#SBATCH --partition=batch
#SBATCH --account=graphlab
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --mem=10G
#SBATCH --time=2:00:00
# #SBATCH --output=compilation_output.txt

module purge
module load GCC/11.3.0
module load UCX
module list

CLUSTER=lucia/mpich make info
CLUSTER=lucia/mpich make install
