# build recipe for FFTW
#===============================================================================
# useful variables
FFTW_DIR = fftw-$(FFTW_VER)

#===============================================================================
.PHONY: fftw
.NOTPARALLEL: fftw
fftw: $(COMP_DIR)/fftw.complete

#-------------------------------------------------------------------------------
$(COMP_DIR)/fftw.complete: make_dir ompi
ifdef FFTW_VER
	cd $(COMP_DIR) ;\
	cp $(TAR_DIR)/$(FFTW_DIR).tar.gz $(COMP_DIR) ;\
	tar -xvf $(FFTW_DIR).tar.gz ;\
	cd $(FFTW_DIR) ;\
	CC=mpicc CXX=mpic++ FC=mpif90 F77=mpif77 ./configure --prefix=${PREFIX} \
	   --disable-fortran --enable-avx --enable-openmp --enable-sse2 ;\
	make install -j ;\
	cd $(COMP_DIR) ;\
	date > fftw.complete ;\
	hostname >> fftw.complete
else
	touch $(COMP_DIR)/fftw.complete
endif

#-------------------------------------------------------------------------------
.PHONY: fftw_info
.NOTPARALLEL: fftw_info
fftw_info:
	$(info --------------------------------------------------------------------------------)
	$(info FFTW)
ifdef FFTW_VER
	$(info - version: $(FFTW_VER))
else
	$(info not built)
endif
	$(info )

#-------------------------------------------------------------------------------
.PHONY: fftw_clean
fftw_clean: 
	@rm -rf fftw.complete
