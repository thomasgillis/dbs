# build recipe for OFI aka libfabric
#===============================================================================
# useful variables
OFI_DIR = libfabric-$(OFI_VER)

#===============================================================================
.PHONY: ofi
ofi: $(PREFIX)/ofi.complete

ofi_tar: $(TAR_DIR)/v$(OFI_VER).tar.gz | make_dir

$(TAR_DIR)/v$(OFI_VER).tar.gz:
	cd $(TAR_DIR); \
	wget 'https://github.com/ofiwg/libfabric/archive/refs/tags/v$(OFI_VER).tar.gz'

#-------------------------------------------------------------------------------
.DELETE_ON_ERROR:
$(PREFIX)/ofi.complete: | make_dir $(TAR_DIR)/v$(OFI_VER).tar.gz
ifdef OFI_VER
	cd $(COMP_DIR) ;\
	cp $(TAR_DIR)/v$(OFI_VER).tar.gz $(COMP_DIR) ;\
	tar -xvf v$(OFI_VER).tar.gz ;\
	cd $(OFI_DIR) ;\
	./autogen.sh ;\
	CC=$(CC) CXX=$(CXX) FC=$(FC) F77=$(FC) ./configure --prefix=${PREFIX} ;\
	make install -j ;\
	date > $@ ;\
	hostname >> $@
else
	touch $(PREFIX)/ofi.complete
endif

#-------------------------------------------------------------------------------
.PHONY: ofi_info
.NOTPARALLEL: ofi_info
ofi_info:
ifdef OFI_VER
	$(info - OFI (aka LibFabric) version: $(OFI_VER))
else
	$(info - OFI (aka LibFabric) not built)
endif

#-------------------------------------------------------------------------------
.PHONY: ofi_clean
ofi_clean: 
	@rm -rf ofi.complete
