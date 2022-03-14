# # build recipe for OFI
#-------------------------------------------------------------------------------
# dependency list
ofi_dep =

define ofi_template_opt
	target="ofi" \
	target_ver="$(OFI_VER)" \
	target_dep="$(ofi_dep)" \
	target_url="https://github.com/ofiwg/libfabric/archive/refs/tags/v$(OFI_VER).tar.gz" \
	target_confcmd="CC=$(CC) CXX=$(CXX) FC=$(FC) F77=$(FC) ./configure --prefix=${PREFIX}"
endef

#===============================================================================
.PHONY: ofi
ofi: $(ofi_dep)
ifdef OFI_VER
	@$(ofi_template_opt) $(MAKE) --file=template.mak doit
else
	@$(ofi_template_opt) $(MAKE) --file=template.mak tit
endif

#-------------------------------------------------------------------------------
.PHONY: ofi_tar
ofi_tar: 
ifdef OFI_VER
	@$(ofi_template_opt) $(MAKE) --file=template.mak tar
else
	@$(ofi_template_opt) $(MAKE) --file=template.mak ttar
endif

#-------------------------------------------------------------------------------
.PHONY: ofi_info
ofi_info:
ifdef OFI_VER
	@$(ofi_template_opt) $(MAKE) --file=template.mak info
else
	@$(ofi_template_opt) $(MAKE) --file=template.mak info_none
endif

#-------------------------------------------------------------------------------
.PHONY: ofi_clean
ofi_clean: 
	@$(ofi_template_opt) $(MAKE) --file=template.mak clean

#-------------------------------------------------------------------------------
.PHONY: ofi_reallyclean
ofi_reallyclean: 
	@$(ofi_template_opt) $(MAKE) --file=template.mak reallyclean


# # build recipe for OFI aka libfabric
# #===============================================================================
# # useful variables
# OFI_DIR = libfabric-$(OFI_VER)

# OFI_DEP =

# #===============================================================================
# .PHONY: ofi
# ofi: $(PREFIX)/ofi.complete

# .PHONY: ofi_tar
# ofi_tar: $(TAR_DIR)/ofi-$(OFI_VER).tar.gz

# $(TAR_DIR)/ofi-$(OFI_VER).tar.gz: | $(TAR_DIR)
# ifdef OFI_VER
# 	cd $(TAR_DIR) &&  \
# 	wget 'https://github.com/ofiwg/libfabric/archive/refs/tags/v$(OFI_VER).tar.gz' &&\
# 	mv v$(OFI_VER).tar.gz ofi-$(OFI_VER).tar.gz
# else
# 	touch $(TAR_DIR)/ofi-$(OFI_VER).tar.gz
# endif

# #-------------------------------------------------------------------------------
# $(PREFIX)/ofi.complete: | $(PREFIX) $(TAR_DIR)/ofi-$(OFI_VER).tar.gz
# ifdef OFI_VER
# 	mkdir -p $(COMP_DIR)  && \
# 	cd $(COMP_DIR)  && \
# 	cp $(TAR_DIR)/ofi-$(OFI_VER).tar.gz $(COMP_DIR)  && \
# 	tar -xvf ofi-$(OFI_VER).tar.gz  && \
# 	cd $(OFI_DIR)  && \
# 	./autogen.sh  && \
# 	CC=$(CC) CXX=$(CXX) FC=$(FC) F77=$(FC) ./configure --prefix=${PREFIX}  && \
# 	$(MAKE) install -j 8 && \
# 	date > $@  && \
# 	hostname >> $@
# else
# 	touch $(PREFIX)/ofi.complete
# endif

# #-------------------------------------------------------------------------------
# .PHONY: ofi_info
# .NOTPARALLEL: ofi_info
# ofi_info:
# ifdef OFI_VER
# 	$(info - OFI (aka LibFabric) version: $(OFI_VER))
# else
# 	$(info - OFI (aka LibFabric) not built)
# endif

# #-------------------------------------------------------------------------------
# .PHONY: ofi_clean
# ofi_clean: 
# 	@rm -rf $(PREFIX)/ofi.complete
# #-------------------------------------------------------------------------------
# .PHONY: ofi_reallyclean
# ofi_reallyclean: 
# 	@rm -rf $(TAR_DIR)/ofi-$(OFI_VER).tar.gz

