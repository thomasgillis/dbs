#!/bin/bash -l
#SBATCH --partition=batch
#SBATCH --time=2:00:00
#SBATCH --ntasks=8
#SBATCH --nodes=1

echo "loading modules"
#-------------------------------------------------------------------------------
module purge
module load releases/2021b
module load GCC/11.2.0
module load Automake Autoconf libtool CMake
#-------------------------------------------------------------------------------
module list
#-------------------------------------------------------------------------------
CLUSTER=lm3/mpich make info
CLUSTER=lm3/mpich make install
#-------------------------------------------------------------------------------
