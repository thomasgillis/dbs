# # build recipe for LIBEVENT
#-------------------------------------------------------------------------------
# dependency list
libevent_dep = 

define libevent_template_opt
	target="libevent" \
	target_ver="$(LIBEVENT_VER)" \
	target_dep="$(libevent_dep)" \
	target_url="https://github.com/libevent/libevent/releases/download/release-$(LIBEVENT_VER)-stable/libevent-$(LIBEVENT_VER)-stable.tar.gz" \
	target_confcmd="CC=$(CC) CXX=$(CXX) FC=$(FC) F77=$(FC) ./configure --prefix=${DBS_PREFIX}" \
	target_confopt="--disable-openssl"
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
ifdef LIBEVENT_VER
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

