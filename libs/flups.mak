# build recipe for FLUPS
#===============================================================================
# useful variables
FLUPS_DIR = flups-$(FLUPS_VER)

ifdef FLUPS_VER
FLUPS_CXXFLAGS = -fopenmp -O3 -g -std=c++11 -DNDEBUG
FLUPS_CCFLAGS = -fopenmp -O3 -g -std=c99 -DNDEBUG
FLUPS_LDFLAGS = -fopenmp -lstdc++
endif 

# fill some of the optional parameters
flups_opt ?= 

# hdf5
ifdef HDF5_VER
flups_opt += HDF5_DIR=${PREFIX}
else
flups_opt += HDF5_DIR=$(strip ${FLUPS_HDF5_DIR})
ifndef FLUPS_HDF5_DIR
ifdef FLUPS_VER
$(error "FLUPS needs to know where to find HDF5, plese define FLUPS_HDF5_DIR")
endif
endif
endif

# h3lpr
ifndef H3LPR_VER
ifdef FLUPS_VER
$(error "H3LPR_VER must be given for FLUPS")
endif
else
flups_opt += H3LPR_DIR=$(PREFIX)
endif

# fftw
ifdef FFTW_VER
flups_opt += FFTW_DIR=${PREFIX}
else
flups_opt += FFTW_DIR=$(strip ${FLUPS_FFTW_DIR})
ifndef FLUPS_FFTW_DIR
ifdef FLUPS_VER
$(error "FLUPS needs to know where to find FFTW, plese define FLUPS_FFTW_DIR")
endif
endif
endif

#===============================================================================
.PHONY: flups
flups: ompi hdf5 h3lpr fftw $(PREFIX)/flups.complete

#-------------------------------------------------------------------------------
flups_tar: $(TAR_DIR)/$(FLUPS_DIR).tar.gz

$(TAR_DIR)/$(FLUPS_DIR).tar.gz: | $(TAR_DIR)
ifdef FLUPS_VER
	cd $(TAR_DIR) &&  \
	rm -rf $(FLUPS_DIR) && \
	git clone git@git.immc.ucl.ac.be:examples/flups.git && \
	mv flups $(FLUPS_DIR) && \
	cd $(FLUPS_DIR) && \
	git checkout --track origin/$(FLUPS_VER) && \
	cd $(TAR_DIR)  && tar -czvf $(FLUPS_DIR).tar.gz $(FLUPS_DIR) && \
	rm -rf $(FLUPS_DIR)  
else
	touch $(TAR_DIR)/$(FLUPS_DIR).tar.gz
endif

#-------------------------------------------------------------------------------
$(PREFIX)/flups.complete: | $(PREFIX) $(TAR_DIR)/$(FLUPS_DIR).tar.gz
ifdef FLUPS_VER
	mkdir -p $(COMP_DIR)  && \
	cd $(COMP_DIR)  && \
	cp $(TAR_DIR)/$(FLUPS_DIR).tar.gz $(COMP_DIR)  && \
	tar -xvf $(FLUPS_DIR).tar.gz  && \
	cd $(FLUPS_DIR) && \
	CC=${DBS_MPICC} CXX=${DBS_MPICXX} \
		CXXFLAGS="$(FLUPS_CXXFLAGS)" CCFLAGS="$(FLUPS_CCFLAGS)" LDFLAGS="$(FLUPS_LDFLAGS)" \
		$(flups_opt) \
		ARCH_FILE=make_arch/make.default \
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
ifdef FLUPS_VER
	$(info - FLUPS branch: $(FLUPS_VER))
	@echo "  > opt: $(flups_opt)"
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
