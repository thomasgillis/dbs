# build recipe for OMPI
#===============================================================================
# useful variables
OMPI_DIR = openmpi-$(OMPI_VER)

#===============================================================================
.PHONY: ompi
ompi: ucx ofi $(PREFIX)/ompi.complete

#-------------------------------------------------------------------------------
.PHONY: ompi_tar
ompi_tar: $(TAR_DIR)/$(OMPI_DIR).tar.gz 

$(TAR_DIR)/$(OMPI_DIR).tar.gz: | $(TAR_DIR)
ifdef OMPI_VER
	cd $(TAR_DIR) &&  \
	wget 'https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-$(OMPI_VER).tar.gz'
else
	touch $(TAR_DIR)/$(OMPI_DIR).tar.gz
endif

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
ifdef LIBEVENT_VER
OMPI_LIBEVENT_DEP = --with-libevent=$(PREFIX)
endif
ifdef HWLOC_VER
OMPI_HWLOC_DEP = --with-hwloc=$(PREFIX)
endif
ifdef ZLIB_VER
OMPI_ZLIB_DEP = --with-zlib=$(PREFIX)
endif
ifdef PMIX_VER
OMPI_PMIX_DEP = --with-pmix=$(PREFIX)
endif

#-------------------------------------------------------------------------------
ifdef OMPI_VER
MPICC = $(PREFIX)/bin/mpicc
MPICXX = $(PREFIX)/bin/mpic++
MPIFORT = $(PREFIX)/bin/mpif90
else
MPICC = mpicc
MPICXX = mpic++
MPIFORT = mpif90
endif

#-------------------------------------------------------------------------------
$(PREFIX)/ompi.complete:  | $(PREFIX) $(TAR_DIR)/$(OMPI_DIR).tar.gz
ifdef OMPI_VER
	mkdir -p $(COMP_DIR)  && \
	cd $(COMP_DIR)  && \
	cp $(TAR_DIR)/$(OMPI_DIR).tar.gz $(COMP_DIR)  && \
	tar -xvf $(OMPI_DIR).tar.gz  && \
	cd $(OMPI_DIR)  && \
	CC=$(CC) CXX=$(CXX) FC=$(FC) F77=$(FC) ./configure --prefix=${PREFIX} \
		--without-verbs --enable-mpirun-prefix-by-default --with-cuda=no \
		$(OMPI_OFI_DEP) $(OMPI_UCX_DEP) $(OMPI_MISC_DEP)  && \
	$(MAKE) install -j 8 && \
	date > $@  && \
	hostname >> $@
else
	touch $(PREFIX)/ompi.complete
endif

#-------------------------------------------------------------------------------
.PHONY: ompi_info
.NOTPARALLEL: ompi_info
ompi_info:
ifdef OMPI_VER
	$(info - OMPI version: $(OMPI_VER) and ofi/ucx?: $(OMPI_OFI_DEP) $(OMPI_UCX_DEP) $(OMPI_MISC_DEP))
	$(info -      ofi/ucx?: $(OMPI_OFI_DEP) $(OMPI_UCX_DEP) $(OMPI_MISC_DEP))
	$(info -      pmix/...?: $(OMPI_LIBEVENT_DEP) $(OMPI_HWLOC_DEP) $(OMPI_ZLIB_DEP) $(OMPI_PMIX_DEP))
else
	$(info - OMPI not built)
endif

#-------------------------------------------------------------------------------
.PHONY: ompi_reallyclean
ompi_reallyclean: 
	@rm -rf $(TAR_DIR)/$(OMPI_DIR).tar.gz
#-------------------------------------------------------------------------------
.PHONY: ompi_clean
ompi_clean: 
	@rm -rf $(PREFIX)/ompi.complete


