# build recipe for OMPI
#===============================================================================
# useful variables
OMPI_DIR = openmpi-$(OMPI_VER)

#===============================================================================
.PHONY: ompi

#===============================================================================
ompi: $(COMP_DIR)/ompi.complete

#-------------------------------------------------------------------------------
ifdef OFI_VER
OMPI_OFI_DEP = --with-ofi=$(PREFIX)
else
OMPI_OFI_DEP = --with-ofi=no
endif
ifdef UCX_VER
OMPI_UCX_DEP = --with-ucx=$(PREFIX)
else
OMPI_UCX_DEP = --with-ucx=no
endif

#-------------------------------------------------------------------------------
$(COMP_DIR)/ompi.complete: make_dir ucx ofi
ifdef OMPI_VER
	cd $(COMP_DIR) ;\
	cp $(TAR_DIR)/$(OMPI_DIR).tar.gz $(COMP_DIR) ;\
	tar -xvf $(OMPI_DIR).tar.gz ;\
	cd $(OMPI_DIR) ;\
	CC=$(CC) CXX=$(CXX) FC=$(FC) F77=$(FC) ./configure --prefix=${PREFIX} \
		--without-verbs --enable-mpirun-prefix-by-default --with-cuda=no \
		$(OMPI_OFI_DEP) $(OMPI_UCX_DEP) ;\
	make install -j ;\
	cd $(COMP_DIR) ;\
	date > ompi.complete ;\
	hostname >> ompi.complete ;\
else
	touch $(COMP_DIR)/ompi.complete
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


