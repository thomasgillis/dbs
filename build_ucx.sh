#!/bin/bash
#SBATCH --partition=sched_mit_wvanrees
#SBATCH --time=6:30:00
#SBATCH --ntasks=36

#-------------------------------------------------------------------------------
TAG=`date '+%Y-%m-%d-%H%M'`-`uuidgen -t | head -c 8`
#BUILD_DIR=/nobackup1/tgillis/build-OpenMPI-${TAG}
BUILD_DIR=/pool001/tgillis/build-OpenMPI-${TAG}
mkdir -p ${BUILD_DIR}

#-------------------------------------------------------------------------------
module purge 
module load gcc/11.2.0 OpenBLAS/0.2.0

#------------------------------------------------------------------------------
export PREFIX=$HOME/lib-OpenMPI-4.1.2-UCX-1.12.0-GCC-11.2
export PATH=${PREFIX}/bin:$PATH
export CFLAGS="-O3 -march=haswell"
export CXXFLAGS="-O3 -march=haswell"

rm -rf ${PREFIX}

#------------------------------------------------------------------------------
#wget https://github.com/openucx/ucx/releases/download/v1.11.2/ucx-1.11.2.tar.gz
#cp ${HOME}/ucx-1.11.2.tar.gz ${BUILD_DIR}
#cd ${BUILD_DIR}
#tar -xvf ucx-1.11.2.tar.gz
#cd ucx-1.11.2
cp ${HOME}/ucx-1.12.0.tar.gz ${BUILD_DIR}
cd ${BUILD_DIR}
tar -xvf ucx-1.12.0.tar.gz
cd ucx-1.12.0
CC=gcc CXX=g++ F77=gfortran F90=gfortran ./configure --prefix=${PREFIX} --enable-compiler-opt=3
make install 
cd ../..


##wget https://github.com/ofiwg/libfabric/archive/refs/tags/v1.14.0.tar.gz
#cp ${HOME}/v1.14.0.tar.gz ${BUILD_DIR}
#cd ${BUILD_DIR}
#tar -xvf v1.14.0.tar.gz 
#cd libfabric-1.14.0
#./autogen.sh
#CC=gcc CXX=g++ F77=gfortran F90=gfortran ./configure --prefix=${PREFIX}
#make install 
#cd ../..

# wget https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.2.tar.gz
cp ${HOME}/openmpi-4.1.2.tar.gz ${BUILD_DIR}
cd ${BUILD_DIR}
tar -xvf openmpi-4.1.2.tar.gz
cd openmpi-4.1.2
CC=gcc CXX=g++ F77=gfortran F90=gfortran ./configure --prefix=$PREFIX \
    --without-verbs --enable-mpirun-prefix-by-default --with-cuda=no \
    --with-ofi=no --with-ucx=${PREFIX}
    #--with-ofi=${PREFIX} --with-ucx=${PREFIX}
    #--with-pmix=${EBROOTPMIX} --with-hwloc=${EBROOTHWLOC} --with-libevent=${EBROOTLIBEVENT}
    #--enable-mca-no-build=btl-uct \
make install
cd ../..

#-------------------------------------------------------------------------------
cp ${HOME}/hdf5-1.12.1.tar ${BUILD_DIR}
cd ${BUILD_DIR}
tar -xvf hdf5-1.12.1.tar
cd hdf5-1.12.1/
CC=mpicc CXX=mpic++ F77=mpif77 F90=mpif90 ./configure --prefix=${PREFIX} --enable-parallel --enable-optimization=high --enable-build-mode=production --with-default-api-version=v110
make install
cd ../..

# ------------------------------------------------------------------------------
# p4est
# wget https://p4est.github.io/release/p4est-2.3.3.tar.gz
#cp ${HOME}/p4est-2.3.3.tar.gz ${BUILD_DIR}
#cd ${BUILD_DIR}
#tar -xvf p4est-2.3.3.tar.gz
#cd p4est-2.3.3/
#wget https://github.com/p4est/p4est.github.io/blob/master/release/p4est-2.8.tar.gz
cp ${HOME}/p4est-2.8.tar.gz ${BUILD_DIR}
cd ${BUILD_DIR}
tar -xvf p4est-2.8.tar.gz
cd p4est-2.8/
CC=mpicc CXX=mpic++ F77=mpif77 F90=mpif90 ./configure --prefix=${PREFIX} --enable-mpi --enable-openmp --with-blas=-lopenblas
make install
cd ../..



