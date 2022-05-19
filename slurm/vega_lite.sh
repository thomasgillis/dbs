#!/bin/bash
#SBATCH --partition=cpu
#SBATCH --time=6:00:00
#SBATCH --ntasks=8
#SBATCH --account=d2202-040-users

#-------------------------------------------------------------------------------
module purge
module load OpenMPI/4.1.3-GCC-11.2.0
module load CMake/3.21.1-GCCcore-11.2.0
#-------------------------------------------------------------------------------
module list
#-------------------------------------------------------------------------------
CLUSTER=vega_lite make info
CLUSTER=vega_lite make install
#-------------------------------------------------------------------------------
