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
COMP_DIR := $(BUILD_DIR)/tmp_dbs-$(TAG)-$(UID)

#===============================================================================
# list of the differents libs supported
include ucx.mak
include ofi.mak
include ompi.mak
include hdf5.mak
include fftw.mak
include p4est.mak
include oblas.mak
include flups.mak

#===============================================================================
.PHONY: submit 
submit: | tar
	sbatch scripts/$(CLUSTER).sh

.PHONY: install
install: ucx ofi ompi hdf5 fftw p4est oblas flups

.PHONY: tar
tar: ucx_tar ofi_tar ompi_tar hdf5_tar fftw_tar p4est_tar oblas_tar flups_tar

.PHONY: info
.NOTPARALLEL: info
info: logo module gen_info ucx_info ofi_info ompi_info hdf5_info fftw_info p4est_info oblas_info flups_info

.PHONY: clean
clean: ucx_clean ofi_clean ompi_clean hdf5_clean fftw_clean p4est_clean oblas_clean flups_clean
	@rm -rf $(PREFIX)/*

.PHONY: reallyclean
reallyclean: clean ucx_reallyclean ofi_reallyclean ompi_reallyclean hdf5_reallyclean fftw_reallyclean p4est_reallyclean oblas_reallyclean flups_reallyclean

#===============================================================================
$(TAR_DIR):
	mkdir -p $(TAR_DIR)
$(COMP_DIR):
	mkdir -p $(COMP_DIR)
$(PREFIX):
	mkdir -p $(PREFIX)

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

#===============================================================================
space:= $(empty) $(empty)

.PHONY: logo
.NOTPARALLEL: logo
logo:
	$(info )
	$(info $(space)  ██████╗ ██████╗ ███████╗ )
	$(info $(space)  ██╔══██╗██╔══██╗██╔════╝ )
	$(info $(space)  ██║  ██║██████╔╝███████╗ )
	$(info $(space)  ██║  ██║██╔══██╗╚════██║ )
	$(info $(space)  ██████╔╝██████╔╝███████║ )
	$(info $(space)  ╚═════╝ ╚═════╝ ╚══════╝ )
	$(info $(space) -- Depency Build System --)
	$(info )


#ofi_clean ompi_clean
	



