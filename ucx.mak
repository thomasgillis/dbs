# build recipe for UCX
#===============================================================================
# useful variables
UCX_DIR = ucx-$(UCX_VER)

#===============================================================================
.PHONY: ucx
ucx: $(PREFIX)/ucx.complete

ucx_tar: $(TAR_DIR)/$(UCX_DIR).tar.gz | make_dir

$(TAR_DIR)/$(UCX_DIR).tar.gz:
	cd $(TAR_DIR); \
	wget 'https://github.com/openucx/ucx/releases/download/v$(UCX_VER)/ucx-$(UCX_VER).tar.gz'


#-------------------------------------------------------------------------------
.DELETE_ON_ERROR:
$(PREFIX)/ucx.complete: | make_dir $(TAR_DIR)/$(UCX_DIR).tar.gz
ifdef UCX_VER
	cd $(COMP_DIR) ;\
	cp $(TAR_DIR)/$(UCX_DIR).tar.gz $(COMP_DIR) ;\
	tar -xvf $(UCX_DIR).tar.gz ;\
	cd $(UCX_DIR) ;\
	CC=$(CC) CXX=$(CXX) FC=$(FC) F77=$(FC) ./configure --prefix=${PREFIX} --enable-compiler-opt=3 ;\
	make install -j ;\
	date > $@ ;\
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
