#!/bin/bash -l
#SBATCH --partition=cpu
#SBATCH --time=2:00:00
#SBATCH --ntasks=8
#SBATCH --nodes=1
#SBATCH --account=p200067
#SBATCH --qos=short

echo "loading modules"
#-------------------------------------------------------------------------------
module use /apps/USE/easybuild/release/2021.5/modules/all
module load GCC/10.3.0
module load Automake/1.16.3-GCCcore-10.3.0
module load Autoconf/2.71-GCCcore-10.3.0
module load libtool/2.4.6-GCCcore-10.3.0
module load CMake/3.20.1-GCCcore-10.3.0
#-------------------------------------------------------------------------------
module list
#-------------------------------------------------------------------------------
CLUSTER=mlx/mpich make info
CLUSTER=mlx/mpich make install
#-------------------------------------------------------------------------------
