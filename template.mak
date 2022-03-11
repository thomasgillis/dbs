#===============================================================================
# template build recipe to be applied for every function
# to used it define the following variables
# - target: the lib name
# - target_url the url to be used in the wget
# - target_ver: the version of the lib
# - target_dep (optional, default: empty): the dependencies of the target
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
target_dir = $(target)-$(traget_ver)

# we handle the optional variables
target_precmd ?=
target_confopt ?=
target_installcmd != $(MAKE) install -j8


#===============================================================================
.PHONY: doit
doit: $(PREFIX)/$(target).complete

.PHONY: touchit
touchit: $(foreach lib,$(target_dep),$(PREFIX)/$(lib).complete)  | $(PREFIX)
	touch $(PREFIX)/$(target).complete

.PHONY: tar
tar: $(TAR_DIR)/$(target)-$(traget_ver).tar.gz

#-------------------------------------------------------------------------------
$(TAR_DIR)/$(target_dir).tar.gz: | $(TAR_DIR)
	echo "$(url)"
	cd $(TAR_DIR) &&\
	wget $(target_url) - O $(target_dir).tar.gz

$(PREFIX)/$(target).complete: $(foreach lib,$(target_dep),$(PREFIX)/$(lib).complete)  | $(PREFIX) $(TAR_DIR)/$(target_dir).tar.gz
	mkdir -p $(COMP_DIR)  && cd $(COMP_DIR) &&\
	cp $(TAR_DIR)/$(target_dir).tar.gz $(COMP_DIR) &&\
	tar -xvf $(TAR_DIR)/$(target_dir).tar.gz -O $(target_dir) --strip-components=1 &&\
	cd $(target_dir) && \
	$(target_precmd) && \
	$(target_confcmd) $(target_compopt)&& \
	$(target_installcmd) && \
	date > $@  && \
	hostname >> $@


#-------------------------------------------------------------------------------
.PHONY: template_clean
template_clean: 
	@rm -rf $(PREFIX)/$(target).complete
#-------------------------------------------------------------------------------
.PHONY: template_reallyclean
template_reallyclean: 
	@rm -rf $(TAR_DIR)/$(target_dir).tar.gz

#-------------------------------------------------------------------------------
.PHONY: template_info
template_info:
	@echo "- $(target):"
	@echo "  > version: $(target_ver)"
	@echo "  > dependencies: $(target_dep)"
	@echo "  > opt: $(target_confopt)"

#-------------------------------------------------------------------------------
.PHONY: template_info_none
template_info_none:
	@echo "- $(target) skipped"

#-------------------------------------------------------------------------------