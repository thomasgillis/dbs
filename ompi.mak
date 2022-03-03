# build recipe for UCX
#===============================================================================
# useful variables
OMPI_DIR = openmpi-$(OMPI_VER)

#===============================================================================
.PHONY: ompi

#===============================================================================
ompi: $(COMP_DIR)/ompi.complete

#-------------------------------------------------------------------------------
$(COMP_DIR)/ompi.complete: make_dir
ifdef OMPI_VER
	cd $(COMP_DIR)
	cp $(TAR_DIR)/$(OMPI_DIR).tar.gz $(COMP_DIR)
	tar -xvf $(OMPI_DIR).tar.gz
	cd $(OMPI_DIR)
	CC=$(CC) CXX=$(CXX) FC=$(FC) F77=$(FC) ./configure --prefix=${PREFIX} \
		--without-verbs --enable-mpirun-prefix-by-default --with-cuda=no \
		$(OMPI_CONFIG)
	make install -j
	cd $(COMP_DIR)
	date > ompi.complete
	hostname >> ompi.complete
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
	$(info - user config: $(OMPI_CONFIG))
else
	$(info not built)
endif
	$(info )

#-------------------------------------------------------------------------------
.PHONY: ompi_clean
ompi_clean: 
	@rm -rf ompi.complete


