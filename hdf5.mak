# build recipe for HDF5
#===============================================================================
# useful variables
HDF5_DIR = hdf5-$(HDF5_VER)

#===============================================================================
.PHONY: hdf5
.NOTPARALLEL: hdf5
hdf5: $(PREFIX)/hdf5.complete

COMP_DIR := $(BUILD_DIR)/tmp-ucx-$(TAG)-$(UID)

#-------------------------------------------------------------------------------
$(PREFIX)/hdf5.complete: ompi
ifdef HDF5_VER
	mkdir -p $(COMP_DIR) ;\
	cd $(COMP_DIR) ;\
	cp $(TAR_DIR)/$(HDF5_DIR).tar.bz2 $(COMP_DIR) ;\
	tar -xvf $(HDF5_DIR).tar.bz2 ;\
	cd $(HDF5_DIR) ;\
	CC=mpicc CXX=mpic++ FC=mpif90 F77=mpif77 ./configure --prefix=${PREFIX} \
	   --enable-parallel --enable-optimization=high --enable-build-mode=production --with-default-api-version=v110 ;\
	make install -j ;\
	date > $(PREFIX)/hdf5.complete ;\
	hostname >> $(PREFIX)/hdf5.complete
else
	touch $(PREFIX)/hdf5.complete
endif

#-------------------------------------------------------------------------------
.PHONY: hdf5_info
.NOTPARALLEL: hdf5_info
hdf5_info:
	$(info --------------------------------------------------------------------------------)
	$(info HDF5)
ifdef HDF5_VER
	$(info - version: $(HDF5_VER))
else
	$(info not built)
endif
	$(info )

#-------------------------------------------------------------------------------
.PHONY: hdf5_clean
hdf5_clean: 
	@rm -rf hdf5.complete
