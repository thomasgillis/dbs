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
# detects which lib is available
LIBLIST := $(notdir $(basename $(wildcard *.mak)))

# generate usefull lists
LIBLIST_MAK = $(foreach lib,$(LIBLIST),$(lib).mak)
LIBLIST_INFO = $(foreach lib,$(LIBLIST),$(lib)_info)
LIBLIST_TAR = $(foreach lib,$(LIBLIST),$(lib)_tar)
LIBLIST_CLEAN = $(foreach lib,$(LIBLIST),$(lib)_clean)
LIBLIST_RCLEAN = $(foreach lib,$(LIBLIST),$(lib)_reallyclean)

include $(LIBLIST_MAK)


#===============================================================================
.PHONY: submit 
submit: | tar
	sbatch scripts/$(CLUSTER).sh

.PHONY: install
install: $(LIBLIST)

.PHONY: tar
tar: $(LIBLIST_TAR)

.NOTPARALLEL: info
.PHONY: info
info: logo module gen_info $(LIBLIST_INFO)

.PHONY: clean
clean: $(LIBLIST_CLEAN)
	@rm -rf $(PREFIX)/*

.PHONY: reallyclean
reallyclean: clean $(LIBLIST_RCLEAN)

.PHONY: universe
universe: submit

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
	



