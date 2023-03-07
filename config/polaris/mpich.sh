#!/bin/bash -l
#PBS -N dbs
#PBS -l walltime=01:00:00
#PBS -l select=2:system=polaris
#PBS -l place=scatter
#PBS -q debug
#PBS -l filesystems=home:grand:eagle
#PBS -A CSC250STPM09

cd ${PBS_O_WORKDIR}

#-------------------------------------------------------------------------------
module load nvhpc
module load libfabric/1.11.0.4.125
#-------------------------------------------------------------------------------
module list
#-------------------------------------------------------------------------------
CLUSTER=polaris/mpich make info
CLUSTER=polaris/mpich make install

# get the number of nodes and process per nodes
NN=`wc -l < $PBS_NODEFILE`
if [[${NN} -eq 1]];
then PPN=2;
else PPN=1;
fi

OSU_NP=${NN} OSU_PPN=${PPN} CLUSTER=polaris/mpich make osu_lat
OSU_NP=${NN} OSU_PPN=${PPN} CLUSTER=polaris/mpich make osu_bw
#-------------------------------------------------------------------------------
