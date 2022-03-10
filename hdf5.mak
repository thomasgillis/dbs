# build recipe for HDF5
#===============================================================================
# useful variables
HDF5_DIR = hdf5-$(HDF5_VER)

#===============================================================================
.PHONY: hdf5
.NOTPARALLEL: hdf5
hdf5: ompi $(PREFIX)/hdf5.complete

#-------------------------------------------------------------------------------
.PHONY: hdf5tar
hdf5_tar: $(TAR_DIR)/$(HDF5_DIR).tar.bz2

$(TAR_DIR)/$(HDF5_DIR).tar.bz2: | $(TAR_DIR)
ifdef HDF5_VER
	cd $(TAR_DIR) &&  \
	wget 'http://www.hdfgroup.org/ftp/HDF5/releases/hdf5-1.12/hdf5-$(HDF5_VER)/src/hdf5-$(HDF5_VER).tar.bz2'
else
	touch $(TAR_DIR)/$(HDF5_DIR).tar.bz2
endif

ifdef ZLIB_VER
	HDF5_ZLIB_DEP = --with-zlib=$(PREFIX)
endif

#-------------------------------------------------------------------------------
$(PREFIX)/hdf5.complete:  | $(PREFIX) $(TAR_DIR)/$(HDF5_DIR).tar.bz2
ifdef HDF5_VER
	mkdir -p $(COMP_DIR)  && \
	cd $(COMP_DIR)  &&\
	cp $(TAR_DIR)/$(HDF5_DIR).tar.bz2 $(COMP_DIR)  &&\
	tar -xvf $(HDF5_DIR).tar.bz2  &&\
	cd $(HDF5_DIR)  &&\
	CC=$(MPICC) CXX=$(MPICXX) FC=$(MPIFORT) F77=$(MPIFORT) ./configure --prefix=${PREFIX} \
		$(HDF5_ZLIB_DEP) \
	  	--enable-parallel --enable-optimization=high --enable-build-mode=production --with-default-api-version=v110  &&\
	$(MAKE) install -j 8 &&\
	date > $@  &&\
	hostname >> $@
else
	touch $(PREFIX)/hdf5.complete
endif

#-------------------------------------------------------------------------------
.PHONY: hdf5_info
.NOTPARALLEL: hdf5_info
hdf5_info:
ifdef HDF5_VER
	$(info - HDF5 version: $(HDF5_VER))
else
	$(info - HDF5 not built)
endif

#-------------------------------------------------------------------------------
.PHONY: hdf5_reallyclean
hdf5_reallyclean: 
	@rm -rf $(TAR_DIR)/$(HDF5_DIR).tar.bz2
#-------------------------------------------------------------------------------
.PHONY: hdf5_clean
hdf5_clean: 
	@rm -rf $(PREFIX)/hdf5.complete
