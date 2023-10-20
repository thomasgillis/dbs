#!/bin/bash
#SBATCH --partition=cpu
#SBATCH --time=6:00:00
#SBATCH --ntasks=8

#-------------------------------------------------------------------------------
module purge
#module load GCC/11.2.0 PMIx/4.1.0-GCCcore-11.2.0 hwloc/2.5.0-GCCcore-11.2.0 libevent/2.1.12-GCCcore-11.2.0
module load GCC/11.2.0 
#-------------------------------------------------------------------------------
module list
#-------------------------------------------------------------------------------
CLUSTER=vega_ucxonly make info
CLUSTER=vega_ucxonly make install
#-------------------------------------------------------------------------------
