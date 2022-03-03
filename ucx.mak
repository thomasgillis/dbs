# build recipe for UCX
#===============================================================================
# useful variables
UCX_DIR = ucx-$(UCX_VER)

#===============================================================================
.PHONY: ucx
ucx: $(COMP_DIR)/ucx.complete

#-------------------------------------------------------------------------------
$(COMP_DIR)/ucx.complete: make_dir
ifdef UCX_VER
	cd $(COMP_DIR)
	cp $(TAR_DIR)/$(UCX_DIR).tar.gz $(COMP_DIR)
	tar -xvf $(UCX_DIR).tar.gz
	cd $(UCX_DIR)
	CC=$(CC) CXX=$(CXX) FC=$(FC) F77=$(FC) ./configure --prefix=${PREFIX} --enable-compiler-opt=3
	make install -j
	cd $(COMP_DIR)
	date > ucx.complete
	hostname >> ucx.complete
else
	@touch $(COMP_DIR)/ucx.complete
endif

#-------------------------------------------------------------------------------
.PHONY: ucx_info
.NOTPARALLEL: ucx_info
ucx_info:
	$(info --------------------------------------------------------------------------------)
	$(info UCX)
ifdef UCX_VER
	$(info - version: $(UCX_VER))
else
	$(info not built)
endif
	$(info )

#-------------------------------------------------------------------------------
.PHONY: ucx_clean
ucx_clean: 
	@rm -rf ucx.complete
