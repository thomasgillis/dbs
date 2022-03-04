# build recipe for P4EST
#===============================================================================
# useful variables
P4EST_DIR = p4est-$(P4EST_VER)

#===============================================================================
.PHONY: p4est
.NOTPARALLEL: p4est
p4est: $(PREFIX)/p4est.complete

COMP_DIR := $(BUILD_DIR)/tmp-ucx-$(TAG)-$(UID)

#-------------------------------------------------------------------------------
$(PREFIX)/p4est.complete: ompi oblas
ifdef P4EST_VER
	mkdir -p $(COMP_DIR) ;\
	cd $(COMP_DIR) ;\
	cp $(TAR_DIR)/$(P4EST_DIR).tar.gz $(COMP_DIR) ;\
	tar -xvf $(P4EST_DIR).tar.gz ;\
	cd $(P4EST_DIR) ;\
	CC=mpicc CXX=mpic++ FC=mpif90 F77=mpif77 ./configure --prefix=${PREFIX} \
	   --enable-mpi --enable-openmp --with-blas=-lopenblas ;\
	make install -j ;\
	date > $(PREFIX)/p4est.complete ;\
	hostname >> $(PREFIX)/p4est.complete
else
	touch $(PREFIX)/p4est.complete
endif

#-------------------------------------------------------------------------------
.PHONY: p4est_info
.NOTPARALLEL: p4est_info
p4est_info:
	$(info --------------------------------------------------------------------------------)
	$(info P4EST)
ifdef P4EST_VER
	$(info - version: $(P4EST_VER))
else
	$(info not built)
endif
	$(info )

#-------------------------------------------------------------------------------
.PHONY: p4est_clean
p4est_clean: 
	@rm -rf p4est.complete
