# build recipe for FLUPS
#===============================================================================
# useful variables
FLUPS_DIR = flups-$(FLUPS_VER)

#===============================================================================
.PHONY: flups
.NOTPARALLEL: flups
flups: ompi hdf5 fftw $(PREFIX)/flups.complete

#-------------------------------------------------------------------------------
flups_tar: $(TAR_DIR)/$(FLUPS_DIR).tar.gz

$(TAR_DIR)/$(FLUPS_DIR).tar.gz: | $(TAR_DIR)
ifdef FLUPS_VER
	cd $(TAR_DIR) &&  \
	rm -rf $(FLUPS_DIR) && \
	git clone git@git.immc.ucl.ac.be:examples/flups.git $(FLUPS_DIR) && \
	cd $(FLUPS_DIR) && \
	git checkout --track origin/dev-node-centered && \
	cd $(TAR_DIR) && tar -czvf $(FLUPS_DIR).tar.gz $(FLUPS_DIR) && \
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
	cd $(FLUPS_DIR) && GITCOMMIT=$(git describe --always --dirty) && cd - && \
	mv $(FLUPS_DIR) $(FLUPS_DIR)-$(GITCOMMIT) && \
	cd $(FLUPS_DIR)-$(GITCOMMIT) && \
	ARCH_FILE=make_arch/make.dbs MPICC=$(MPICC) MPICXX=$(MPICXX) HDF5_DIR=$(PREFIX) FFTW_DIR=$(PREFIX) $(MAKE) intall -j 8 && \ 
	date > $@  && \
	hostname >> $@ && \ 
	$(GITCOMMIT) >> $@
else
	touch $(PREFIX)/flups.complete
endif

#-------------------------------------------------------------------------------
.PHONY: flups_info
.NOTPARALLEL: flups_info
flups_info:
ifdef FLUPS_VER
	$(info - FLUPS version: $(FLUPS_VER))
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
