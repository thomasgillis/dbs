#!/bin/bash -l
#SBATCH --partition=standard
#SBATCH --time=6:00:00
#SBATCH --ntasks=8
#SBATCH --nodes=1
#SBATCH --account=project_465000098

echo "loading modules"
#-------------------------------------------------------------------------------
module load CrayEnv
module load libfabric/1.15.0.0
#-------------------------------------------------------------------------------
module list
#-------------------------------------------------------------------------------
CLUSTER=lumi make info
CLUSTER=lumi make install
#-------------------------------------------------------------------------------
