# build recipe for FLUPS
#===============================================================================
# useful variables
FLUPS_DIR = flups-$(FLUPS_BRANCH)

ifdef FLUPS_BRANCH
FLUPS_CXXFLAGS = -fopenmp -O3 -g -std=c++11
FLUPS_CCFLAGS = -fopenmp -O3 -g -std=c99
FLUPS_LDFLAGS = -fopenmp -lstdc++
endif 


#===============================================================================
.PHONY: flups
flups: ompi hdf5 fftw $(PREFIX)/flups.complete

#-------------------------------------------------------------------------------
flups_tar: $(TAR_DIR)/$(FLUPS_DIR).tar.gz

$(TAR_DIR)/$(FLUPS_DIR).tar.gz: | $(TAR_DIR)
ifdef FLUPS_BRANCH
	cd $(TAR_DIR) &&  \
	rm -rf $(FLUPS_DIR) && \
	git clone git@git.immc.ucl.ac.be:examples/flups.git && \
	mv flups $(FLUPS_DIR) && \
	cd $(FLUPS_DIR) && \
	git checkout --track origin/$(FLUPS_BRANCH) && \
	cd $(TAR_DIR)  && tar -czvf $(FLUPS_DIR).tar.gz $(FLUPS_DIR) && \
	rm -rf $(FLUPS_DIR)  
else
	touch $(TAR_DIR)/$(FLUPS_DIR).tar.gz
endif

#-------------------------------------------------------------------------------
$(PREFIX)/flups.complete: | $(PREFIX) $(TAR_DIR)/$(FLUPS_DIR).tar.gz
ifdef FLUPS_BRANCH
	mkdir -p $(COMP_DIR)  && \
	cd $(COMP_DIR)  && \
	cp $(TAR_DIR)/$(FLUPS_DIR).tar.gz $(COMP_DIR)  && \
	tar -xvf $(FLUPS_DIR).tar.gz  && \
	cd $(FLUPS_DIR) && \
	CC=${MPICC} CXX=${MPICXX} \
		CXXFLAGS="$(FLUPS_CXXFLAGS)" CCFLAGS="$(FLUPS_CCFLAGS)" LDFLAGS="$(FLUPS_LDFLAGS)" \
		HDF5_DIR=${PREFIX} FFTW_DIR=${PREFIX} \
		$(MAKE) install -j 8 && \
	date > $@  && \
	hostname >> $@ && \
	git describe --always --dirty >> $@
else
	touch $(PREFIX)/flups.complete
endif

#-------------------------------------------------------------------------------
.PHONY: flups_info
.NOTPARALLEL: flups_info
flups_info:
ifdef FLUPS_BRANCH
	$(info - FLUPS branch: $(FLUPS_BRANCH))
else
	$(info - FLUPS not built)
endif

#-------------------------------------------------------------------------------
.PHONY: flups_reallyclean
flups_reallyclean: 
	@rm -rf $(TAR_DIR)/$(FLUPS_DIR).tar.gz
#-------------------------------------------------------------------------------
.PHONY: flups_clean
flups_clean: 
	@rm -rf $(PREFIX)/flups.complete
