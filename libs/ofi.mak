# # build recipe for OFI
#-------------------------------------------------------------------------------
# dependency list
ofi_dep = zlib
# from https://github.com/easybuilders/easybuild-easyconfigs/blob/develop/easybuild/easyconfigs/l/libfabric
ofi_opt = --disable-usnic --disable-sockets

define ofi_template_opt
	target="ofi" \
	target_ver="$(OFI_VER)" \
	target_dep="$(ofi_dep)" \
	target_url="https://github.com/ofiwg/libfabric/archive/refs/tags/v$(OFI_VER).tar.gz" \
	target_precmd="./autogen.sh" \
	target_confcmd="CC=$(CC) CXX=$(CXX) FC=$(FC) F77=$(FC) ./configure --prefix=${PREFIX}" \
	target_confopt="$(ofi_opt)"
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


