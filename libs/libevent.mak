# # build recipe for LIBEVENT
#-------------------------------------------------------------------------------
# dependency list
libevent_dep = 

define libevent_template_opt
	target="libevent" \
	target_ver="$(LIBEVENT_VER)" \
	target_dep="$(libevent_dep)" \
	target_url="https://github.com/libevent/libevent/releases/download/release-$(LIBEVENT_VER)-stable/libevent-$(LIBEVENT_VER)-stable.tar.gz" \
	target_confcmd="CC=$(CC) CXX=$(CXX) FC=$(FC) F77=$(FC) ./configure --prefix=${PREFIX}" \
	target_compopt="--disable-openssl"
endef

#===============================================================================
.PHONY: libevent
libevent: $(libevent_dep)
ifdef LIBEVENT_VER
	@$(libevent_template_opt) $(MAKE) --file=template.mak doit
else
	@$(libevent_template_opt) $(MAKE) --file=template.mak tit
endif

#-------------------------------------------------------------------------------
.PHONY: libevent_tar
libevent_tar: 
ifdef ZLIB_VER
	@$(libevent_template_opt) $(MAKE) --file=template.mak tar
else
	@$(libevent_template_opt) $(MAKE) --file=template.mak ttar
endif

#-------------------------------------------------------------------------------
.PHONY: libevent_info
libevent_info:
ifdef LIBEVENT_VER
	@$(libevent_template_opt) $(MAKE) --file=template.mak info
else
	@$(libevent_template_opt) $(MAKE) --file=template.mak info_none
endif

#-------------------------------------------------------------------------------
.PHONY: libevent_clean
libevent_clean: 
	@$(libevent_template_opt) $(MAKE) --file=template.mak clean

#-------------------------------------------------------------------------------
.PHONY: libevent_reallyclean
libevent_reallyclean: 
	@$(libevent_template_opt) $(MAKE) --file=template.mak reallyclean

# #===============================================================================
# # useful variables
# LIBEVENT_DIR = libevent-$(LIBEVENT_VER)-stable

# #===============================================================================
# .PHONY: libevent
# libevent: $(PREFIX)/libevent.complete

# .PHONY: libevent_tar
# libevent_tar: $(TAR_DIR)/$(LIBEVENT_DIR).tar.gz 

# $(TAR_DIR)/$(LIBEVENT_DIR).tar.gz: | $(TAR_DIR)
# ifdef LIBEVENT_VER
# 	cd $(TAR_DIR)&& \
# 	wget 'https://github.com/libevent/libevent/releases/download/release-$(LIBEVENT_VER)-stable/libevent-$(LIBEVENT_VER)-stable.tar.gz'
# else
# 	touch $(TAR_DIR)/$(LIBEVENT_DIR).tar.gz
# endif

# #-------------------------------------------------------------------------------
# $(PREFIX)/libevent.complete: | $(PREFIX) $(TAR_DIR)/$(LIBEVENT_DIR).tar.gz
# ifdef LIBEVENT_VER
# 	mkdir -p $(COMP_DIR)  && \
# 	cd $(COMP_DIR)  && \
# 	cp $(TAR_DIR)/$(LIBEVENT_DIR).tar.gz $(COMP_DIR)  && \
# 	tar -xvf $(LIBEVENT_DIR).tar.gz  && \
# 	cd $(LIBEVENT_DIR)  && \
# 	CC=$(CC) CXX=$(CXX) FC=$(FC) F77=$(FC) ./configure --prefix=${PREFIX} --disable-openssl && \
# 	$(MAKE) install -j 8 && \
# 	date > $@  && \
# 	hostname >> $@
# else
# 	touch $(PREFIX)/libevent.complete
# endif

# #-------------------------------------------------------------------------------
# .PHONY: libevent_info
# .NOTPARALLEL: libevent_info
# libevent_info:
# ifdef LIBEVENT_VER
# 	$(info - LIBEVENT version: $(LIBEVENT_VER))
# else
# 	$(info - LIBEVENT not built)
# endif

# #-------------------------------------------------------------------------------
# .PHONY: libevent_clean
# libevent_clean: 
# 	@rm -rf $(PREFIX)/libevent.complete

# #-------------------------------------------------------------------------------
# .PHONY: libevent_reallyclean
# libevent_reallyclean: 
# 	@rm -rf $(TAR_DIR)/$(LIBEVENT_DIR).tar.gz

