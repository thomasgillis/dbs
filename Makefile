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
include make_arch/${CLUSTER}.dep

# get the PREFIX and BUILD_DIR
PREFIX ?= ${HOME}
BUILD_DIR ?= ${HOME}
TAR_DIR ?= ${HOME}

#===============================================================================
# list of the differents libs supported
include ucx.mak
# include ofi.mak
# include ompi.mak

.PHONY: clean
clean: ucx_clean


#===============================================================================
.PHONY: info
.NOTPARALLEL: info
info: gen_info ucx_info

#===============================================================================
.NOTPARALLEL: gen_info
.PHONY: gen_info
gen_info:
	$(info --------------------------------------------------------------------------------)
	$(info GENERAL INFO)
	$(info - build for: $(CLUSTER))
	$(info - prefix: $(PREFIX))
	$(info - build dir: $(BUILD_DIR))
	$(info - tar dir: $(TAR_DIR))
	$(info - non-mpi compilers: CC = $(CC); CXX = $(CXX); FC = $(FC);  F77 = $(F77))



#ofi_clean ompi_clean
	



