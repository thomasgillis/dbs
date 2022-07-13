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
# define the cluster by default, overwritten if `CLUSTER=bla make ...`
CLUSTER ?= default

#-------------------------------------------------------------------------------
#include the cluster-dependent information
include clusters/${CLUSTER}.arch 

# include all the lib-related info
include $(LIBLIST_MAK)

#-------------------------------------------------------------------------------
# get the DBS_PREFIX and DBS_BUILD_DIR
DBS_PREFIX ?= ${HOME}
DBS_BUILD_DIR ?= ${HOME}
DBS_TAR_DIR ?= ${HOME}

#-------------------------------------------------------------------------------
# ":=" force the evaluation at creation of the var
UID := $(shell uuidgen -t | head -c 8)
TAG := $(shell date '+%Y-%m-%d-%H%M')
COMP_DIR := $(DBS_BUILD_DIR)/tmp_dbs-$(TAG)-$(UID)


#===============================================================================
.PHONY: submit 
submit: | tar
	sbatch slurm/$(CLUSTER).sh

#-------------------------------------------------------------------------------
.PHONY: install
install: $(LIBLIST)

#-------------------------------------------------------------------------------
.PHONY: tar
tar: $(LIBLIST_TAR)

#-------------------------------------------------------------------------------
.PHONY: liblist
info:
	$(info --------------------------------------------------------------------------------)
	$(info supported libs: $(LIBLIST))
	$(info --------------------------------------------------------------------------------)

#-------------------------------------------------------------------------------
.PHONY: info
info: logo module liblist gen_info $(LIBLIST_INFO)

#-------------------------------------------------------------------------------
.PHONY: clean
clean: $(LIBLIST_CLEAN)
	@rm -rf $(DBS_PREFIX)/*

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
	$(info GENERAL INFO)
	$(info - build for: $(CLUSTER))
	$(info - DBS_PREFIX: $(DBS_PREFIX))
	$(info - build dir: $(DBS_BUILD_DIR))
	$(info - tar dir: $(DBS_TAR_DIR))
	$(info - non-mpi compilers: CC = $(CC); CXX = $(CXX); FC = $(FC))
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


	



