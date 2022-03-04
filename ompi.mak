# build recipe for OMPI
#===============================================================================
# useful variables
OMPI_DIR = openmpi-$(OMPI_VER)

#===============================================================================
.PHONY: ompi

#===============================================================================
ompi: $(PREFIX)/ompi.complete

#-------------------------------------------------------------------------------
ifdef OFI_VER
OMPI_OFI_DEP = --with-ofi=$(PREFIX)
else
OMPI_OFI_DEP ?= --with-ofi=no
endif
ifdef UCX_VER
OMPI_UCX_DEP = --with-ucx=$(PREFIX)
else
OMPI_UCX_DEP ?= --with-ucx=no
endif

COMP_DIR := $(BUILD_DIR)/tmp-ucx-$(TAG)-$(UID)

#-------------------------------------------------------------------------------
$(PREFIX)/ompi.complete: ucx ofi
ifdef OMPI_VER
	mkdir -p $(COMP_DIR) ;\
	cd $(COMP_DIR) ;\
	cp $(TAR_DIR)/$(OMPI_DIR).tar.gz $(COMP_DIR) ;\
	tar -xvf $(OMPI_DIR).tar.gz ;\
	cd $(OMPI_DIR) ;\
	CC=$(CC) CXX=$(CXX) FC=$(FC) F77=$(FC) ./configure --prefix=${PREFIX} \
		--without-verbs --enable-mpirun-prefix-by-default --with-cuda=no \
		$(OMPI_OFI_DEP) $(OMPI_UCX_DEP) ;\
	make install -j ;\
	date > $(PREFIX)/ompi.complete ;\
	hostname >> $(PREFIX)/ompi.complete
else
	touch $(PREFIX)/ompi.complete
endif

#-------------------------------------------------------------------------------
.PHONY: ompi_info
.NOTPARALLEL: ompi_info
ompi_info:
	$(info --------------------------------------------------------------------------------)
	$(info OMPI)
ifdef OMPI_VER
	$(info - version: $(OMPI_VER))
	$(info - ofi/ucx?: $(OMPI_OFI_DEP) $(OMPI_UCX_DEP))
else
	$(info not built)
endif
	$(info )

#-------------------------------------------------------------------------------
.PHONY: ompi_clean
ompi_clean: 
	@rm -rf ompi.complete


