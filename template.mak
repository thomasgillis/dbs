#===============================================================================
# template build recipe to be applied for every function
# to used it define the following variables
# - target: the lib name
# - target_url the url to be used in the wget or the github repo if target_git is given
# - target_ver: the version of the lib
# - target_git: contains the specific branch to clone, the url must be the github repo
# - target_dep: the list of lib that the target depends on
# - target_confcmd: the compilation command to be used (eg `CC=$(CC) CXX=$(CXX) FC=$(FC) F77=$(FC) ./configure --prefix=${PREFIX}`)
# - target_precmd: (optional, default: empty) the precompilation command to run (eg `./autogen.sh`)
# - target_confopt: (optional, default: empty) the compilation options to add to the configure
# - target_installcmd: (optional, default: `$(MAKE) install -j8`)

#===============================================================================
# prevent the parallel execution of this file and the reason is that we want 
# to delegate the paralle execution to the compilation and not to executing multiple
# recipe consequently
.NOTPARALLEL:
.SILENT:

#===============================================================================
# define target specific information
target_dir = $(target)-$(target_ver)

# we handle the optional variables
ifeq ($(strip $(target_git)),)
target_precmd ?= echo "no pre-configure command"
target_confopt ?= 
else
target_precmd ?= ./autogen.sh
target_confopt ?= 
endif
target_installcmd ?= $(MAKE) install -j 8

#===============================================================================
# define how to make the directories
$(PREFIX):
	mkdir -p $(PREFIX)
$(TAR_DIR):
	mkdir -p $(TAR_DIR) $(COMP_DIR):
	mkdir -p $(COMP_DIR)
$(COMP_DIR)/tmp_$(target):
	mkdir -p $(COMP_DIR)/tmp_$(target)


ifeq ($(strip $(target_git)),)
target_folder = $(target_dir).tar.gz
else
target_folder = $(target_dir)_$(target_git).tar.gz
endif

#===============================================================================
.PHONY: doit
doit: $(PREFIX)/$(target).complete

.PHONY: tit
tit: | $(PREFIX)
	touch -a $(PREFIX)/$(target).complete

.PHONY: tar
tar: $(TAR_DIR)/$(target_folder) | $(TAR_DIR)

.PHONY: ttar
ttar: | $(TAR_DIR)
	touch $(TAR_DIR)/$(target_folder)

#-------------------------------------------------------------------------------
# if no target_git is given, use the "traditional way"
$(TAR_DIR)/$(target_folder): | $(TAR_DIR)
ifeq ($(strip $(target_git)),)
	cd $(TAR_DIR) &&\
	wget --no-check-certificate $(target_url) -O $(target_folder)
else
	cd $(TAR_DIR) &&\
	git clone $(target_repo) -b $(target_git) $(target_dir) && \
	tar -czvf $(target_folder) $(target_dir) && \
	rm -rf $(target_dir)
endif

$(PREFIX)/$(target).complete: $(foreach lib,$(target_dep),$(PREFIX)/$(lib).complete) | $(PREFIX) $(COMP_DIR)/tmp_$(target) $(TAR_DIR)/$(target_folder)
	cp $(TAR_DIR)/$(target_folder) $(COMP_DIR)/tmp_$(target) &&\
	cd $(COMP_DIR)/tmp_$(target) &&\
	tar -xvf $(target_folder) &&\
	mv */ $(COMP_DIR)/$(target_dir) &&\
	cd $(COMP_DIR)/$(target_dir) &&\
	$(target_precmd) &&\
	$(target_confcmd) $(target_confopt) &&\
	$(target_installcmd) &&\
	date > $@  &&\
	hostname >> $@


#-------------------------------------------------------------------------------
.PHONY: clean
clean: 
	@rm -rf $(PREFIX)/$(target).complete
#-------------------------------------------------------------------------------
.PHONY: reallyclean
reallyclean: 
	@rm -rf $(TAR_DIR)/$(target_folder)

#-------------------------------------------------------------------------------
.PHONY: info
info:
	@echo "- $(target):"
	@echo "  > version: $(target_ver)"
	@echo "  > dependencies: $(target_dep)"
	@echo "  > opt: $(target_confopt)"

#-------------------------------------------------------------------------------
.PHONY: info_none
info_none:
#	@echo "- $(target) skipped"

#-------------------------------------------------------------------------------
