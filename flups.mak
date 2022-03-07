# build recipe for P4EST
#===============================================================================
# useful variables
FLUPS_DIR = flups-$(FLUPS_VER)

#===============================================================================
.PHONY: flups
.NOTPARALLEL: flups
flups: $(PREFIX)/flups.complete

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
.DELETE_ON_ERROR:
$(PREFIX)/flups.complete: ompi hdf5 fftw | $(PREFIX) $(COMP_DIR) $(TAR_DIR)/$(FLUPS_DIR).tar.gz
ifdef FLUPS_VER
	cd $(COMP_DIR)  && \
	cp $(TAR_DIR)/$(FLUPS_DIR).tar.gz $(COMP_DIR)  && \
	tar -xvf $(FLUPS_DIR).tar.gz  && \
	cd $(FLUPS_DIR) && GITCOMMIT=$(git describe --always --dirty) && cd - && \
	mv $(FLUPS_DIR) $(FLUPS_DIR)-$(GITCOMMIT) && \
	cd $(FLUPS_DIR)-$(GITCOMMIT) && \
	ARCH_FILE=make_arch/make.$(CLUSTER)_ch0k0t0ff HDF5_DIR=$(PREFIX) FFTW_DIR=$(PREFIX) make intall -j && \ 
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
