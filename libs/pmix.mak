# build recipe for PMIX
#-------------------------------------------------------------------------------
pmix_opt = 
# get the correct libevent etc
ifdef LIBEVENT_VER
pmix_opt += --with-libevent=$(PREFIX)
endif
ifdef PMIX_VER
pmix_opt += --with-pmix=$(PREFIX)
endif
ifdef ZLIB_VER
pmix_opt += --with-zlib=$(PREFIX)
endif

$(info $(pmix_opt))

#-------------------------------------------------------------------------------
define pmix_template_opt
	target=pmix \
	target_ver=$(PMIX_VER) \
	target_url="https://github.com/openpmix/openpmix/releases/download/v$(PMIX_VER)/pmix-$(PMIX_VER).tar.gz" \
	target_confcmd="CC=$(CC) CXX=$(CXX) FC=$(FC) F77=$(FC) ./configure --prefix=${PREFIX}"\
	target_dep="zlib libevent pmix"\
	target_confopt="$(pmix_opt)"
endef

#===============================================================================
.PHONY: pmix
pmix:
ifdef PMIX_VER
	@$(pmix_template_opt) $(MAKE) --file=template.mak doit
else
	@$(pmix_template_opt) $(MAKE) --file=template.mak touchit
endif

#-------------------------------------------------------------------------------
.PHONY: pmix_info
pmix_info:
ifdef PMIX_VER
	@$(pmix_template_opt) $(MAKE) --file=template.mak template_info
else
	@$(pmix_template_opt) $(MAKE) --file=template.mak template_info_none
endif

#-------------------------------------------------------------------------------
.PHONY: pmix_clean
pmix_clean: 
	@$(pmix_template_opt) $(MAKE) --file=template.mak tempalte_clean

#-------------------------------------------------------------------------------
.PHONY: pmix_reallyclean
pmix_reallyclean: 
	@$(pmix_template_opt) $(MAKE) --file=template.mak template_reallyclean


# # build recipe for PMIX
# #===============================================================================
# # useful variables
# PMIX_DIR = pmix-$(PMIX_VER)
# PMIX_DEPS = zlib libevent pmix

# #-------------------------------------------------------------------------------
# ifdef LIBEVENT_VER
# PMIX_LIBEVENT_DEP = --with-libevent=$(PREFIX)
# endif
# ifdef PMIX_VER
# PMIX_PMIX_DEP = --with-pmix=$(PREFIX)
# endif
# ifdef ZLIB_VER
# PMIX_ZLIB_DEP = --with-zlib=$(PREFIX)
# endif

# #===============================================================================
# .PHONY: pmix
# pmix: $(PREFIX)/pmix.complete

# #-------------------------------------------------------------------------------
# .PHONY: pmix_tar
# pmix_tar: $(TAR_DIR)/$(PMIX_DIR).tar.gz 

# $(TAR_DIR)/$(PMIX_DIR).tar.gz: | $(TAR_DIR)
# ifdef PMIX_VER
# 	cd $(TAR_DIR)&& \
# 	wget 'https://github.com/openpmix/openpmix/releases/download/v$(PMIX_VER)/pmix-$(PMIX_VER).tar.gz'
# else
# 	touch $(TAR_DIR)/$(PMIX_DIR).tar.gz
# endif

# #-------------------------------------------------------------------------------
# $(PREFIX)/pmix.complete: $(foreach lib,$(PMIX_DEPS),$(PREFIX)/$(lib).complete) | $(PREFIX) $(TAR_DIR)/$(PMIX_DIR).tar.gz
# ifdef PMIX_VER
# 	mkdir -p $(COMP_DIR)  && \
# 	cd $(COMP_DIR)  && \
# 	cp $(TAR_DIR)/$(PMIX_DIR).tar.gz $(COMP_DIR)  && \
# 	tar -xvf $(PMIX_DIR).tar.gz  && \
# 	cd $(PMIX_DIR)  && \
# 	CC=$(CC) CXX=$(CXX) FC=$(FC) F77=$(FC) ./configure --prefix=${PREFIX} \
# 		--enable-pmix-binaries --with-ofi=no \
# 		$(PMIX_LIBEVENT_DEP) $(PMIX_PMIX_DEP) $(PMIX_ZLIB_DEP) && \
# 	$(MAKE) install -j 8 && \
# 	date > $@  && \
# 	hostname >> $@
# else
# 	touch $(PREFIX)/pmix.complete
# endif

# #-------------------------------------------------------------------------------
# .PHONY: pmix_info
# .NOTPARALLEL: pmix_info
# pmix_info:
# ifdef PMIX_VER
# 	$(info - PMIX version: $(PMIX_VER))
# 	$(info $(space)      libevent?: $(PMIX_LIBEVENT_DEP))
# 	$(info $(space)      zlib?: $(PMIX_ZLIB_DEP))
# 	$(info $(space)      pmix?: $(PMIX_PMIX_DEP))
# else
# 	$(info - PMIX not built)
# endif

# #-------------------------------------------------------------------------------
# .PHONY: pmix_clean
# pmix_clean: 
# 	@rm -rf $(PREFIX)/pmix.complete

# #-------------------------------------------------------------------------------
# .PHONY: pmix_reallyclean
# pmix_reallyclean: 
# 	@rm -rf $(TAR_DIR)/$(PMIX_DIR).tar.gz

