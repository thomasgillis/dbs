#!/bin/bash
#SBATCH --qos=debug
#SBATCH --time=0:30:00
#SBATCH --ntasks=8
#SBATCH --account=m4034
#SBATCH --constraint=haswell

#-------------------------------------------------------------------------------
module swap PrgEnv- PrgEnv-gnu/6.0.10
module load cray-hdf5-parallel/1.10.5.2
module unload darshan
module use /global/common/software/m3169/cori/modulefiles
module load openmpi/4.1.2
#-------------------------------------------------------------------------------
module list
#-------------------------------------------------------------------------------
CLUSTER=cori make info
CLUSTER=cori make install
#-------------------------------------------------------------------------------
