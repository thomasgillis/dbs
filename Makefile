#
# DBS - Makefile to build various usefull libraries
#
#===============================================================================
# define generalities for this makefile
.EXPORT_ALL_VARIABLES:
# we forbid the parallel execution to dedicated parallel resources to the compilation of libs
.NOTPARALLEL:

# disable directory printing
MAKEFLAGS += --no-print-directory

#-------------------------------------------------------------------------------
# the first rule encountered is the default one
.PHONY: default
default: info

#===============================================================================
# detects which lib is available
LIBLIST := $(notdir $(basename $(wildcard libs/*.mak)))
# generate usefull lists
LIBLIST_MAK = $(foreach lib,$(LIBLIST),libs/$(lib).mak)
LIBLIST_INFO = $(foreach lib,$(LIBLIST),$(lib)_info)
LIBLIST_TAR = $(foreach lib,$(LIBLIST),$(lib)_tar)
LIBLIST_CLEAN = $(foreach lib,$(LIBLIST),$(lib)_clean)
LIBLIST_RCLEAN = $(foreach lib,$(LIBLIST),$(lib)_reallyclean)

#===============================================================================
# user-defined variables
CLUSTER ?= default
CONF_DIR ?= config
CLUSTERS_DIR ?= ${CONF_DIR}
SUBMIT_DIR ?= ${CONF_DIR}

#include the cluster-dependent information
include ${CLUSTERS_DIR}/${CLUSTER}.arch 

# include all the different library.mak recipes
include $(LIBLIST_MAK)

# allow the user to redefine the submit command
 SUBMIT_CMD ?= sbatch

#-------------------------------------------------------------------------------
# get the PREFIX and BUILD_DIR
PREFIX ?= ${HOME}
BUILD_DIR ?= ${HOME}
TAR_DIR ?= ${HOME}

#export the prefix in the path, it allows to easily find mpi compilers once installed with dbs
#PATH := $(PREFIX)/bin:$(PATH)

#-------------------------------------------------------------------------------
# ":=" forces the evaluation at creation of the var
UID := $(shell uuidgen -t | head -c 8)
TAG := $(shell date '+%Y-%m-%d-%H%M')
COMP_DIR := $(BUILD_DIR)/tmp_dbs-$(TAG)-$(UID)


#===============================================================================
.PHONY: submit 
submit: | tar
	${SUBMIT_CMD} ${SUBMIT_DIR}/$(CLUSTER).sh

#-------------------------------------------------------------------------------
.PHONY: install
install: $(LIBLIST)

#-------------------------------------------------------------------------------
.PHONY: tar
tar: $(LIBLIST_TAR)

#-------------------------------------------------------------------------------
.PHONY: info
info: logo module gen_info $(LIBLIST_INFO)

#-------------------------------------------------------------------------------
.PHONY: clean
clean: $(LIBLIST_CLEAN)
	@rm -rf $(PREFIX)/*

#-------------------------------------------------------------------------------
.PHONY: reallyclean
reallyclean: clean $(LIBLIST_RCLEAN)

#-------------------------------------------------------------------------------
.PHONY: universe
universe: submit

#===============================================================================
# information related rules
space:= $(empty) $(empty)

#-------------------------------------------------------------------------------
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

#-------------------------------------------------------------------------------
.PHONY: gen_info
gen_info:
	$(info --------------------------------------------------------------------------------)
	$(info supported libs: $(LIBLIST))
	$(info --------------------------------------------------------------------------------)
	$(info GENERAL INFO)
	$(info - build for: $(CLUSTER))
	$(info - prefix: $(PREFIX))
	$(info - build dir: $(BUILD_DIR))
	$(info - tar dir: $(TAR_DIR))
	$(info - non-mpi compilers: CC = $(CC); CXX = $(CXX); FC = $(FC))
	$(info - mpi compilers: CC = $(DBS_MPICC); CXX = $(DBS_MPICXX))
	$(info --------------------------------------------------------------------------------)

#-------------------------------------------------------------------------------
.PHONY: logo
logo:
	$(info )
	$(info $(space)   ██████╗ ██████╗ ███████╗  $(space))
	$(info $(space)   ██╔══██╗██╔══██╗██╔════╝  $(space))
	$(info $(space)   ██║  ██║██████╔╝███████╗  $(space))
	$(info $(space)   ██║  ██║██╔══██╗╚════██║  $(space))
	$(info $(space)   ██████╔╝██████╔╝███████║  $(space))
	$(info $(space)   ╚═════╝ ╚═════╝ ╚══════╝  $(space))
	$(info $(space)  -- Depency Build System -- $(space))
	$(info )


	



