# build recipe for HDF5
#===============================================================================
# useful variables
HDF5_DIR = hdf5-$(HDF5_VER)

#===============================================================================
.PHONY: hdf5
.NOTPARALLEL: hdf5
hdf5: $(PREFIX)/hdf5.complete


#-------------------------------------------------------------------------------
.DELETE_ON_ERROR:
$(PREFIX)/hdf5.complete: ompi | make_dir
ifdef HDF5_VER
	cd $(COMP_DIR) ;\
	cp $(TAR_DIR)/$(HDF5_DIR).tar.bz2 $(COMP_DIR) ;\
	tar -xvf $(HDF5_DIR).tar.bz2 ;\
	cd $(HDF5_DIR) ;\
	CC=mpicc CXX=mpic++ FC=mpif90 F77=mpif77 ./configure --prefix=${PREFIX} \
	   --enable-parallel --enable-optimization=high --enable-build-mode=production --with-default-api-version=v110 ;\
	make install -j ;\
	date > $@ ;\
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
.PHONY: hdf5_clean
hdf5_clean: 
	@rm -rf hdf5.complete
