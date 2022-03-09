# build recipe for HWLOC
#===============================================================================
# useful variables
HWLOC_DIR = hwloc-$(HWLOC_VER)

#===============================================================================
.PHONY: hwloc
hwloc: $(PREFIX)/hwloc.complete

.PHONY: hwloc_tar
hwloc_tar: $(TAR_DIR)/$(HWLOC_DIR).tar.gz 

$(TAR_DIR)/$(HWLOC_DIR).tar.gz: | $(TAR_DIR)
ifdef HWLOC_VER
	cd $(TAR_DIR)&& \
	wget 'https://download.open-mpi.org/release/hwloc/v2.7/hwloc-$(HWLOC_VER).tar.gz'
else
	touch $(TAR_DIR)/$(HWLOC_DIR).tar.gz
endif

#-------------------------------------------------------------------------------
$(PREFIX)/hwloc.complete: | $(PREFIX) $(TAR_DIR)/$(HWLOC_DIR).tar.gz
ifdef HWLOC_VER
	mkdir -p $(COMP_DIR)  && \
	cd $(COMP_DIR)  && \
	cp $(TAR_DIR)/$(HWLOC_DIR).tar.gz $(COMP_DIR)  && \
	tar -xvf $(HWLOC_DIR).tar.gz  && \
	cd $(HWLOC_DIR)  && \
	CC=$(CC) CXX=$(CXX) FC=$(FC) F77=$(FC) ./configure --prefix=${PREFIX} && \
	$(MAKE) install -j 8 && \
	date > $@  && \
	hostname >> $@
else
	touch $(PREFIX)/hwloc.complete
endif

#-------------------------------------------------------------------------------
.PHONY: hwloc_info
.NOTPARALLEL: hwloc_info
hwloc_info:
ifdef HWLOC_VER
	$(info - HWLOC version: $(HWLOC_VER))
else
	$(info - HWLOC not built)
endif

#-------------------------------------------------------------------------------
.PHONY: hwloc_clean
hwloc_clean: 
	@rm -rf $(PREFIX)/hwloc.complete

#-------------------------------------------------------------------------------
.PHONY: hwloc_reallyclean
hwloc_reallyclean: 
	@rm -rf $(TAR_DIR)/$(HWLOC_DIR).tar.gz

