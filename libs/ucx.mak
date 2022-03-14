# # build recipe for UCX
#-------------------------------------------------------------------------------
# dependency list
ucx_dep =

define ucx_template_opt
	target="ucx" \
	target_ver="$(UCX_VER)" \
	target_dep="$(ucx_dep)" \
	target_url="https://github.com/openucx/ucx/releases/download/v$(UCX_VER)/ucx-$(UCX_VER).tar.gz" \
	target_confcmd="CC=$(CC) CXX=$(CXX) FC=$(FC) F77=$(FC) ./configure --prefix=${PREFIX}" \
	target_confopt="--enable-compiler-opt=3"
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


# # build recipe for UCX
# #===============================================================================
# # useful variables
# UCX_DIR = ucx-$(UCX_VER)
# UCX_DEP =

# #===============================================================================
# .PHONY: ucx
# ucx: $(PREFIX)/ucx.complete

# .PHONY: ucx_tar
# ucx_tar: $(TAR_DIR)/$(UCX_DIR).tar.gz 

# $(TAR_DIR)/$(UCX_DIR).tar.gz: | $(TAR_DIR)
# ifdef UCX_VER
# 	cd $(TAR_DIR)&& \
# 	wget 'https://github.com/openucx/ucx/releases/download/v$(UCX_VER)/ucx-$(UCX_VER).tar.gz'
# else
# 	touch $(TAR_DIR)/$(UCX_DIR).tar.gz
# endif

# #-------------------------------------------------------------------------------
# $(PREFIX)/ucx.complete: $(foreach lib,$(UCX_DEP),$(PREFIX)/$(lib).complete) | $(PREFIX) $(TAR_DIR)/$(UCX_DIR).tar.gz
# ifdef UCX_VER
# 	mkdir -p $(COMP_DIR)  && \
# 	cd $(COMP_DIR)  && \
# 	cp $(TAR_DIR)/$(UCX_DIR).tar.gz $(COMP_DIR)  && \
# 	tar -xvf $(UCX_DIR).tar.gz  && \
# 	cd $(UCX_DIR)  && \
# 	CC=$(CC) CXX=$(CXX) FC=$(FC) F77=$(FC) ./configure --prefix=${PREFIX} --enable-compiler-opt=3  && \
# 	$(MAKE) install -j 8 && \
# 	date > $@  && \
# 	hostname >> $@
# else
# 	touch $(PREFIX)/ucx.complete
# endif

# #-------------------------------------------------------------------------------
# .PHONY: ucx_info
# .NOTPARALLEL: ucx_info
# ucx_info:
# ifdef UCX_VER
# 	$(info - UCX version: $(UCX_VER))
# else
# 	$(info - UCX not built)
# endif

# #-------------------------------------------------------------------------------
# .PHONY: ucx_clean
# ucx_clean: 
# 	@rm -rf $(PREFIX)/ucx.complete

# #-------------------------------------------------------------------------------
# .PHONY: ucx_reallyclean
# ucx_reallyclean: 
# 	@rm -rf $(TAR_DIR)/$(UCX_DIR).tar.gz

