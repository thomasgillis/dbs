#!/bin/bash -l
#SBATCH --partition=cpu
#SBATCH --time=2:00:00
#SBATCH --ntasks=8
#SBATCH --nodes=1
#SBATCH --account=p200053
#SBATCH --qos=short

#-------------------------------------------------------------------------------
module use /apps/USE/easybuild/staging/2021.1/modules/all
module load HDF5/1.12.1-gompi-2021a
module load FFTW/3.3.10-gompi-2021a
module load OpenMPI/4.1.3-GCC-10.3.0
module load CMake/3.20.1-GCCcore-10.3.0
#-------------------------------------------------------------------------------
module list
#-------------------------------------------------------------------------------
CLUSTER=meluxina make info
CLUSTER=meluxina make install
#-------------------------------------------------------------------------------
