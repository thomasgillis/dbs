# build recipe for OFI aka libfabric
#===============================================================================
# useful variables
OFI_DIR = libfabric-$(OFI_VER)

#===============================================================================
.PHONY: ofi
ofi: $(PREFIX)/ofi.complete

ofi_tar: $(TAR_DIR)/v$(OFI_VER).tar.gz

$(TAR_DIR)/v$(OFI_VER).tar.gz: | $(TAR_DIR)
ifdef OFI_VER
	cd $(TAR_DIR) &&  \
	wget 'https://github.com/ofiwg/libfabric/archive/refs/tags/v$(OFI_VER).tar.gz'
else
	touch $(TAR_DIR)/v$(OFI_VER).tar.gz
endif

#-------------------------------------------------------------------------------
.DELETE_ON_ERROR:
$(PREFIX)/ofi.complete: | $(PREFIX) $(TAR_DIR)/v$(OFI_VER).tar.gz
ifdef OFI_VER
	mkdir -p $(COMP_DIR)  && \
	cd $(COMP_DIR)  && \
	cp $(TAR_DIR)/v$(OFI_VER).tar.gz $(COMP_DIR)  && \
	tar -xvf v$(OFI_VER).tar.gz  && \
	cd $(OFI_DIR)  && \
	./autogen.sh  && \
	CC=$(CC) CXX=$(CXX) FC=$(FC) F77=$(FC) ./configure --prefix=${PREFIX}  && \
	$(MAKE) install -j 8 && \
	date > $@  && \
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
	@rm -rf $(PREFIX)/ofi.complete
#-------------------------------------------------------------------------------
.PHONY: ofi_reallyclean
ofi_reallyclean: 
	@rm -rf $(TAR_DIR)/v$(OFI_VER).tar.gz

