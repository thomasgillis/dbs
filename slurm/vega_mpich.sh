#!/bin/bash -l
#SBATCH --partition=cpu
#SBATCH --time=6:00:00
#SBATCH --ntasks=8

echo "loading modules"
#-------------------------------------------------------------------------------
module load GCC/10.3.0
module load Automake/1.16.3-GCCcore-10.3.0
module load Autoconf/2.71-GCCcore-10.3.0
module load libtool/2.4.6-GCCcore-10.3.0
module load CMake/3.20.1-GCCcore-10.3.0
#-------------------------------------------------------------------------------
module list
#-------------------------------------------------------------------------------
CLUSTER=vega_mpich make info
CLUSTER=vega_mpich make install
#-------------------------------------------------------------------------------
