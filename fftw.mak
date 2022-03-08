# build recipe for FFTW
#===============================================================================
# useful variables
FFTW_DIR = fftw-$(FFTW_VER)

#===============================================================================
.PHONY: fftw
fftw: ompi $(PREFIX)/fftw.complete

#-------------------------------------------------------------------------------
.PHONY: fftw_tar
fftw_tar: $(TAR_DIR)/$(FFTW_DIR).tar.gz 

$(TAR_DIR)/$(FFTW_DIR).tar.gz: | $(TAR_DIR)
ifdef FFTW_VER
	cd $(TAR_DIR) &&  \
	wget 'http://www.fftw.org/fftw-${FFTW_VER}.tar.gz'
else
	touch $(TAR_DIR)/$(FFTW_DIR).tar.gz
endif

#-------------------------------------------------------------------------------
$(PREFIX)/fftw.complete: | $(PREFIX) $(TAR_DIR)/$(FFTW_DIR).tar.gz
ifdef FFTW_VER
	mkdir -p $(COMP_DIR)  && \
	cd $(COMP_DIR)  && \
	cp $(TAR_DIR)/$(FFTW_DIR).tar.gz $(COMP_DIR)  && \
	tar -xvf $(FFTW_DIR).tar.gz  && \
	cd $(FFTW_DIR)  && \
	CC=$(MPICC) CXX=$(MPICXX) FC=$(MPIFORT) F77=$(MPIFORT) ./configure --prefix=${PREFIX} \
	   --disable-fortran --enable-avx --enable-openmp --enable-sse2  && \
	$(MAKE) install -j 8  && \
	date > $@  && \
	hostname >> $@
else
	touch $(PREFIX)/fftw.complete
endif

#-------------------------------------------------------------------------------
.PHONY: fftw_info
.NOTPARALLEL: fftw_info
fftw_info:
ifdef FFTW_VER
	$(info - FFTW version: $(FFTW_VER))
else
	$(info - FFTW not built)
endif

#-------------------------------------------------------------------------------
.PHONY: fftw_reallyclean
fftw_reallyclean: 
	@rm -rf $(TAR_DIR)/$(FFTW_DIR).tar.gz
#-------------------------------------------------------------------------------
.PHONY: fftw_clean
fftw_clean: 
	@rm -rf $(PREFIX)/fftw.complete
