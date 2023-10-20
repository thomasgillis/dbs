#!/bin/bash
#SBATCH --qos=debug
#SBATCH --time=0:20:00
#SBATCH --nodes=1
#SBATCH --ntasks=128
#SBATCH --cpus-per-task=2
#SBATCH --constraint=cpu
#SBATCH --ntasks=1

#-------------------------------------------------------------------------------
module unload gpu 
module load cpu
module swap craype-${CRAY_CPU_TARGET} craype-x86-milan
module swap PrgEnv-${PE_ENV,,} PrgEnv-gnu
module load cray-mpich 
module load cray-hdf5-parallel
module load cray-fftw
module unload cray-libsci
#-------------------------------------------------------------------------------
module list
#-------------------------------------------------------------------------------
CLUSTER=perlmutter/default make info
CLUSTER=perlmutter/default make install
#-------------------------------------------------------------------------------