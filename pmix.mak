# build recipe for PMIX
#===============================================================================
# useful variables
PMIX_DIR = pmix-$(PMIX_VER)

#===============================================================================
.PHONY: pmix
pmix: zlib libevent hwloc $(PREFIX)/pmix.complete

.PHONY: pmix_tar
pmix_tar: $(TAR_DIR)/$(PMIX_DIR).tar.gz 

$(TAR_DIR)/$(PMIX_DIR).tar.gz: | $(TAR_DIR)
ifdef PMIX_VER
	cd $(TAR_DIR)&& \
	wget 'https://github.com/openpmix/openpmix/releases/download/v$(PMIX_VER)/pmix-$(PMIX_VER).tar.gz'
else
	touch $(TAR_DIR)/$(PMIX_DIR).tar.gz
endif

#-------------------------------------------------------------------------------
ifdef LIBEVENT_VER
PMIX_LIBEVENT_DEP = --with-libevent=$(PREFIX)
endif
ifdef HWLOC_VER
PMIX_HWLOC_DEP = --with-hwloc=$(PREFIX)
endif
ifdef ZLIB_VER
PMIX_ZLIB_DEP = --with-zlib=$(PREFIX)
endif

#-------------------------------------------------------------------------------
$(PREFIX)/pmix.complete: | $(PREFIX) $(TAR_DIR)/$(PMIX_DIR).tar.gz
ifdef PMIX_VER
	mkdir -p $(COMP_DIR)  && \
	cd $(COMP_DIR)  && \
	cp $(TAR_DIR)/$(PMIX_DIR).tar.gz $(COMP_DIR)  && \
	tar -xvf $(PMIX_DIR).tar.gz  && \
	cd $(PMIX_DIR)  && \
	CC=$(CC) CXX=$(CXX) FC=$(FC) F77=$(FC) ./configure --prefix=${PREFIX} \
		--enable-pmix-binaries \
		$(PMIX_LIBEVENT_DEP) $(PMIX_HWLOC_DEP) $(PMIX_ZLIB_DEP) && \
	$(MAKE) install -j 8 && \
	date > $@  && \
	hostname >> $@
else
	touch $(PREFIX)/pmix.complete
endif

#-------------------------------------------------------------------------------
.PHONY: pmix_info
.NOTPARALLEL: pmix_info
pmix_info:
ifdef PMIX_VER
	$(info - PMIX version: $(PMIX_VER), hwloc/libevent/zlib? $(PMIX_HWLOC_DEP) $(PMIX_LIBEVENT_DEP) $(PMIX_ZLIB_DEP))
else
	$(info - PMIX not built)
endif

#-------------------------------------------------------------------------------
.PHONY: pmix_clean
pmix_clean: 
	@rm -rf $(PREFIX)/pmix.complete

#-------------------------------------------------------------------------------
.PHONY: pmix_reallyclean
pmix_reallyclean: 
	@rm -rf $(TAR_DIR)/$(PMIX_DIR).tar.gz

