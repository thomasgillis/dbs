# build recipe for OFI aka libfabric
#===============================================================================
# useful variables
OFI_DIR = libfabric-$(OFI_VER)

#===============================================================================
.PHONY: ofi
ofi: $(COMP_DIR)/ofi.complete

#-------------------------------------------------------------------------------
$(COMP_DIR)/ofi.complete:
ifdef OFI_VER
	cd $(COMP_DIR) ;\
	cp $(TAR_DIR)/v$(OFI_VER).tar.gz $(COMP_DIR) ;\
	tar -xvf v$(OFI_VER).tar.gz ;\
	cd $(OFI_DIR) ;\
	./autogen.sh ;\
	CC=$(CC) CXX=$(CXX) FC=$(FC) F77=$(FC) ./configure --prefix=${PREFIX} ;\
	make install -j ;\
	cd $(COMP_DIR) ;\
	date > ofi.complete ;\
	hostname >> ofi.complete
else
	@touch $(COMP_DIR)/ofi.complete
endif

#-------------------------------------------------------------------------------
.PHONY: ofi_info
.NOTPARALLEL: ofi_info
ofi_info:
	$(info --------------------------------------------------------------------------------)
	$(info **OFI** (aka LibFabric))
ifdef OFI_VER
	$(info - version: $(OFI_VER))
else
	$(info not built)
endif
	$(info )

#-------------------------------------------------------------------------------
.PHONY: ofi_clean
ofi_clean: 
	@rm -rf ofi.complete
