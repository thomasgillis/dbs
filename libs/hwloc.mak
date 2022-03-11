# # build recipe for HWLOC
#-------------------------------------------------------------------------------
define hwloc_template_opt
	target=hwloc \
	target_ver=$(HWLOC_VER) \
	target_url="https://download.open-mpi.org/release/hwloc/v2.7/hwloc-$(HWLOC_VER).tar.gz" \
	target_confcmd="CC=$(CC) CXX=$(CXX) FC=$(FC) F77=$(FC) ./configure --prefix=${PREFIX}"
endef

#===============================================================================
.PHONY: hwloc
hwloc:
ifdef HWLOC_VER
	@$(hwloc_template_opt) $(MAKE) --file=template.mak doit
else
	@$(hwloc_template_opt) $(MAKE) --file=template.mak touchit
endif

#-------------------------------------------------------------------------------
.PHONY: hwloc_info
hwloc_info:
ifdef HWLOC_VER
	@$(hwloc_template_opt) $(MAKE) --file=template.mak template_info
else
	@$(hwloc_template_opt) $(MAKE) --file=template.mak template_info_none
endif

#-------------------------------------------------------------------------------
.PHONY: hwloc_clean
hwloc_clean: 
	@$(hwloc_template_opt) $(MAKE) --file=template.mak tempalte_clean

#-------------------------------------------------------------------------------
.PHONY: hwloc_reallyclean
hwloc_reallyclean: 
	@$(hwloc_template_opt) $(MAKE) --file=template.mak template_reallyclean

# # build recipe for HWLOC
# #===============================================================================
# # useful variables
# HWLOC_DIR = hwloc-$(HWLOC_VER)

# #===============================================================================
# .PHONY: hwloc
# hwloc: $(PREFIX)/hwloc.complete

# .PHONY: hwloc_tar
# hwloc_tar: $(TAR_DIR)/$(HWLOC_DIR).tar.gz 

# $(TAR_DIR)/$(HWLOC_DIR).tar.gz: | $(TAR_DIR)
# ifdef HWLOC_VER
# 	cd $(TAR_DIR)&& \
# 	wget 'https://download.open-mpi.org/release/hwloc/v2.7/hwloc-$(HWLOC_VER).tar.gz'
# else
# 	touch $(TAR_DIR)/$(HWLOC_DIR).tar.gz
# endif

# #-------------------------------------------------------------------------------
# $(PREFIX)/hwloc.complete: | $(PREFIX) $(TAR_DIR)/$(HWLOC_DIR).tar.gz
# ifdef HWLOC_VER
# 	mkdir -p $(COMP_DIR)  && \
# 	cd $(COMP_DIR)  && \
# 	cp $(TAR_DIR)/$(HWLOC_DIR).tar.gz $(COMP_DIR)  && \
# 	tar -xvf $(HWLOC_DIR).tar.gz  && \
# 	cd $(HWLOC_DIR)  && \
# 	CC=$(CC) CXX=$(CXX) FC=$(FC) F77=$(FC) ./configure --prefix=${PREFIX} && \
# 	$(MAKE) install -j 8 && \
# 	date > $@  && \
# 	hostname >> $@
# else
# 	touch $(PREFIX)/hwloc.complete
# endif

# #-------------------------------------------------------------------------------
# .PHONY: hwloc_info
# .NOTPARALLEL: hwloc_info
# hwloc_info:
# ifdef HWLOC_VER
# 	$(info - HWLOC version: $(HWLOC_VER))
# else
# 	$(info - HWLOC not built)
# endif

# #-------------------------------------------------------------------------------
# .PHONY: hwloc_clean
# hwloc_clean: 
# 	@rm -rf $(PREFIX)/hwloc.complete

# #-------------------------------------------------------------------------------
# .PHONY: hwloc_reallyclean
# hwloc_reallyclean: 
# 	@rm -rf $(TAR_DIR)/$(HWLOC_DIR).tar.gz

