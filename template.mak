#===============================================================================
# template build recipe to be applied for every function
# to used it define the following variables
# - target: the lib name
# - target_url the url to be used in the wget
# - target_ver: the version of the lib
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

#===============================================================================
# define target specific information
target_dir = $(target)-$(target_ver)

# we handle the optional variables
target_precmd ?= echo "no pre-configure command"
target_confopt ?= $(empty)
target_installcmd ?= $(MAKE) install -j8

#===============================================================================
# define how to make the directories
$(PREFIX):
	mkdir -p $(PREFIX)
$(TAR_DIR):
	mkdir -p $(TAR_DIR)
$(COMP_DIR):
	mkdir -p $(COMP_DIR)
$(COMP_DIR)/tmp_$(target):
	mkdir -p $(COMP_DIR)/tmp_$(target)

#===============================================================================
.PHONY: doit
doit: $(PREFIX)/$(target).complete

.PHONY: tit
tit:  | $(PREFIX)
	touch $(PREFIX)/$(target).complete

.PHONY: tar
tar: $(TAR_DIR)/$(target)-$(traget_ver).tar.gz

.PHONY: ttar
ttar:
	touch $(TAR_DIR)/$(target)-$(traget_ver).tar.gz

#-------------------------------------------------------------------------------
$(TAR_DIR)/$(target_dir).tar.gz: | $(TAR_DIR)
	cd $(TAR_DIR) &&\
	wget $(target_url) -O $(target_dir).tar.gz

$(PREFIX)/$(target).complete: $(foreach lib,$(target_dep),$(PREFIX)/$(lib).complete) | $(PREFIX) $(COMP_DIR) $(COMP_DIR)/tmp_$(target) $(TAR_DIR)/$(target_dir).tar.gz
	cp $(TAR_DIR)/$(target_dir).tar.gz $(COMP_DIR)/tmp_$(target) &&\
	cd $(COMP_DIR)/tmp_$(target) &&\
	tar -xvf $(target_dir).tar.gz &&\
	mv */ $(COMP_DIR)/$(target_dir) &&\
	cd $(COMP_DIR)/$(target_dir) &&\
	$(target_precmd) &&\
	$(target_confcmd) $(target_compopt) &&\
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
	@rm -rf $(TAR_DIR)/$(target_dir).tar.gz

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
	@echo "- $(target) skipped"

#-------------------------------------------------------------------------------
