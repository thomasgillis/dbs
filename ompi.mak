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

#-------------------------------------------------------------------------------
.DELETE_ON_ERROR:
$(PREFIX)/ompi.complete: ucx ofi | make_dir
ifdef OMPI_VER
	cd $(COMP_DIR) ;\
	cp $(TAR_DIR)/$(OMPI_DIR).tar.gz $(COMP_DIR) ;\
	tar -xvf $(OMPI_DIR).tar.gz ;\
	cd $(OMPI_DIR) ;\
	CC=$(CC) CXX=$(CXX) FC=$(FC) F77=$(FC) ./configure --prefix=${PREFIX} \
		--without-verbs --enable-mpirun-prefix-by-default --with-cuda=no \
		$(OMPI_OFI_DEP) $(OMPI_UCX_DEP) ;\
	make install -j ;\
	date > $@ ;\
	hostname >> $@
else
	touch $(PREFIX)/ompi.complete
endif

#-------------------------------------------------------------------------------
.PHONY: ompi_info
.NOTPARALLEL: ompi_info
ompi_info:
ifdef OMPI_VER
	$(info - OMPI version: $(OMPI_VER) and ofi/ucx?: $(OMPI_OFI_DEP) $(OMPI_UCX_DEP))
else
	$(info - OMPI not built)
endif

#-------------------------------------------------------------------------------
.PHONY: ompi_clean
ompi_clean: 
	@rm -rf ompi.complete


