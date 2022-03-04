# build recipe for UCX
#===============================================================================
# useful variables
UCX_DIR = ucx-$(UCX_VER)

#===============================================================================
.PHONY: ucx
ucx: $(PREFIX)/ucx.complete

COMP_DIR := $(BUILD_DIR)/tmp-ucx-$(TAG)-$(UID)

#-------------------------------------------------------------------------------
$(PREFIX)/ucx.complete:
ifdef UCX_VER
	mkdir -p $(COMP_DIR) ;\
	cd $(COMP_DIR) ;\
	cp $(TAR_DIR)/$(UCX_DIR).tar.gz $(COMP_DIR) ;\
	tar -xvf $(UCX_DIR).tar.gz ;\
	cd $(UCX_DIR) ;\
	CC=$(CC) CXX=$(CXX) FC=$(FC) F77=$(FC) ./configure --prefix=${PREFIX} --enable-compiler-opt=3 ;\
	make install -j ;\
	date > $(PREFIX)/ucx.complete ;\
	hostname >> $(PREFIX)/ucx.complete ;\
else
	@touch $(PREFIX)/ucx.complete
endif

#-------------------------------------------------------------------------------
.PHONY: ucx_info
.NOTPARALLEL: ucx_info
ucx_info:
	$(info --------------------------------------------------------------------------------)
	$(info **UCX**)
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
