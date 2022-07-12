#!/bin/bash
### #SBATCH --qos=debug
#SBATCH --partition=RM
#SBATCH --time=1:30:00
#SBATCH --ntasks=8
#SBATCH --account=phy220014p
### #SBATCH --constraint=haswelddl

#-------------------------------------------------------------------------------
module purge
module load gcc/10.2.0
#-------------------------------------------------------------------------------
module list
#-------------------------------------------------------------------------------
CLUSTER=bridges2 make info
CLUSTER=bridges2 make install
#-------------------------------------------------------------------------------
