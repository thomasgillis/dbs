# get the different tar's
# usage: ./tar-list.sh or TAR_DIR=/my/dir ./tar-list.sh
#

mkdir -p ${TAR_DIR:=${HOME}}
cd ${TAR_DIR:=${HOME}}
pwd

#===============================================================================
# UCX
wget 'https://github.com/openucx/ucx/releases/download/v1.12.0/ucx-1.12.0.tar.gz'
#wget 'https://github.com/openucx/ucx/releases/download/v1.11.2/ucx-1.11.2.tar.gz'

#===============================================================================
# OFI
wget 'https://github.com/ofiwg/libfabric/archive/refs/tags/v1.14.0.tar.gz'

#===============================================================================
# OMPI
wget 'https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.2.tar.gz'

#===============================================================================
# OpenBlas
wget 'https://github.com/xianyi/OpenBLAS/archive/v0.3.18.tar.gz'

#===============================================================================
# HDF5
wget 'http://www.hdfgroup.org/ftp/HDF5/releases/hdf5-1.12/hdf5-1.12.1/src/hdf5-1.12.1.tar.bz2'

#===============================================================================
# p4est
wget 'https://p4est.github.io/release/p4est-2.8.tar.gz'

#===============================================================================
# FFTW
wget 'http://www.fftw.org/fftw-3.3.10.tar.gz'
