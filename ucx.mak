# build recipe for UCX
#===============================================================================
# useful variables
UCX_DIR = ucx-$(UCX_VER)

#===============================================================================
.PHONY: ucx
ucx: $(PREFIX)/ucx.complete

.PHONY: ucx_tar
ucx_tar: $(TAR_DIR)/$(UCX_DIR).tar.gz 

$(TAR_DIR)/$(UCX_DIR).tar.gz: | $(TAR_DIR)
ifdef UCX_VER
	cd $(TAR_DIR)&& \
	wget 'https://github.com/openucx/ucx/releases/download/v$(UCX_VER)/ucx-$(UCX_VER).tar.gz'
else
	touch $(TAR_DIR)/$(UCX_DIR).tar.gz
endif

#-------------------------------------------------------------------------------
$(PREFIX)/ucx.complete: | $(PREFIX) $(TAR_DIR)/$(UCX_DIR).tar.gz
ifdef UCX_VER
	mkdir -p $(COMP_DIR)  && \
	cd $(COMP_DIR)  && \
	cp $(TAR_DIR)/$(UCX_DIR).tar.gz $(COMP_DIR)  && \
	tar -xvf $(UCX_DIR).tar.gz  && \
	cd $(UCX_DIR)  && \
	CC=$(CC) CXX=$(CXX) FC=$(FC) F77=$(FC) ./configure --prefix=${PREFIX} --enable-compiler-opt=3  && \
	$(MAKE) install -j 8 && \
	date > $@  && \
	hostname >> $@
else
	touch $(PREFIX)/ucx.complete
endif

#-------------------------------------------------------------------------------
.PHONY: ucx_info
.NOTPARALLEL: ucx_info
ucx_info:
ifdef UCX_VER
	$(info - UCX version: $(UCX_VER))
else
	$(info - UCX not built)
endif

#-------------------------------------------------------------------------------
.PHONY: ucx_clean
ucx_clean: 
	@rm -rf $(PREFIX)/ucx.complete

#-------------------------------------------------------------------------------
.PHONY: ucx_reallyclean
ucx_reallyclean: 
	@rm -rf $(TAR_DIR)/$(UCX_DIR).tar.gz

