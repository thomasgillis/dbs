# Makefile to build various usefull libraries
#
#===============================================================================
# the main idea is to generate a small file lib.complete when the lib has been build
# when the file is removed, the lib is recompiled
# 
# for more informations
# useful links: 
# - automatic vars: https://www.gnu.org/software/make/manual/html_node/Automatic-Variables.html
# - file names: https://www.gnu.org/software/make/manual/html_node/File-Name-Functions.html
#===============================================================================

# define the cluster by default, overwritten if `CLUSTER=bla make ...`
CLUSTER ?= default

#===============================================================================
#include the cluster-dependent information
include make_arch/${CLUSTER}.arch 

# get the PREFIX and BUILD_DIR
PREFIX ?= ${HOME}
BUILD_DIR ?= ${HOME}
TAR_DIR ?= ${HOME}

#===============================================================================
# ":=" force the evaluation at creation of the var
UID := $(shell uuidgen -t | head -c 8)
TAG := $(shell date '+%Y-%m-%d-%H%M')
COMP_DIR := $(BUILD_DIR)/tmp_chktff-$(TAG)-$(UID)

#===============================================================================
# list of the differents libs supported
include ucx.mak
include ofi.mak
include ompi.mak
include hdf5.mak
include fftw.mak
include p4est.mak
include oblas.mak

#===============================================================================
.PHONY: default
default: all

.PHONY: all
all: info install

.PHONY: install
install: make_dir ucx ofi ompi hdf5 fftw p4est oblas

.PHONY: make_dir
make_dir: 
	mkdir -p $(COMP_DIR)
	mkdir -p $(PREFIX)

#===============================================================================
.PHONY: info
.NOTPARALLEL: info
info: module gen_info ucx_info ofi_info ompi_info hdf5_info fftw_info p4est_info oblas_info

.PHONY: clean
clean: ucx_clean ofi_clean ompi_clean hdf5_clean fftw_clean p4est_clean oblas_clean
	@rm -rf $(PREFIX)



#===============================================================================
.PHONY: module
module:
ifdef MODULE_LIST
	$(info --------------------------------------------------------------------------------)
	$(info module(s) to load:)
	$(info $(MODULE_LIST))
	$(info )
else
	$(info --------------------------------------------------------------------------------)
	$(info no module requested)
endif

.PHONY: gen_info
gen_info:
	$(info --------------------------------------------------------------------------------)
	$(info GENERAL INFO)
	$(info - build for: $(CLUSTER))
	$(info - prefix: $(PREFIX))
	$(info - build dir: $(BUILD_DIR))
	$(info - tar dir: $(TAR_DIR))
	$(info - non-mpi compilers: CC = $(CC); CXX = $(CXX); FC = $(FC))
	$(info --------------------------------------------------------------------------------)



#ofi_clean ompi_clean
	



