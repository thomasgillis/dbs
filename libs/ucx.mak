# # build recipe for UCX
#-------------------------------------------------------------------------------
# dependency list
ucx_dep = zlib numa
ucx_opt = --enable-optimizations --enable-cma --enable-mt --with-verbs --without-java --without-go --disable-doxygen-doc

ifdef NUMA_VER
ucx_opt += --enable-numa --with-numa=$(DBS_PREFIX)
else ifdef NUMA_DIR
ucx_opt += --enable-numa --with-numa=$(NUMA_DIR)
else
$(warning "No libnuma given for UCX, this will affect performances")
endif

define ucx_template_opt
	target="ucx" \
	target_ver="$(UCX_VER)" \
	target_dep="$(ucx_dep)" \
	target_url="https://github.com/openucx/ucx/releases/download/v$(UCX_VER)/ucx-$(UCX_VER).tar.gz" \
	target_confcmd="CC=$(CC) CXX=$(CXX) FC=$(FC) F77=$(FC) ./contrib/configure-release --prefix=${DBS_PREFIX}" \
	target_confopt="$(ucx_opt)"
endef

#===============================================================================
.PHONY: ucx
ucx: $(ucx_dep)
ifdef UCX_VER
	@$(ucx_template_opt) $(MAKE) --file=template.mak doit
else
	@$(ucx_template_opt) $(MAKE) --file=template.mak tit
endif

#-------------------------------------------------------------------------------
.PHONY: ucx_tar
ucx_tar: 
ifdef UCX_VER
	@$(ucx_template_opt) $(MAKE) --file=template.mak tar
else
	@$(ucx_template_opt) $(MAKE) --file=template.mak ttar
endif

#-------------------------------------------------------------------------------
.PHONY: ucx_info
ucx_info:
ifdef UCX_VER
	@$(ucx_template_opt) $(MAKE) --file=template.mak info
else
	@$(ucx_template_opt) $(MAKE) --file=template.mak info_none
endif

#-------------------------------------------------------------------------------
.PHONY: ucx_clean
ucx_clean: 
	@$(ucx_template_opt) $(MAKE) --file=template.mak clean

#-------------------------------------------------------------------------------
.PHONY: ucx_reallyclean
ucx_reallyclean: 
	@$(ucx_template_opt) $(MAKE) --file=template.mak reallyclean
