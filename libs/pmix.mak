# build recipe for PMIX
#-------------------------------------------------------------------------------
# define the deps
pmix_dep = zlib libevent hwloc ofi

# get the options
pmix_opt ?= --enable-pmix-binaries

# get the correct libevent etc
ifdef LIBEVENT_VER
pmix_opt += --with-libevent=$(PREFIX)
endif
ifdef HWLOC_VER
pmix_opt += --with-hwloc=$(PREFIX)
endif
ifdef ZLIB_VER
pmix_opt += --with-zlib=$(PREFIX)
endif
ifdef OFI_VER
pmix_opt += --with-ofi=$(PREFIX)
endif

#-------------------------------------------------------------------------------
# get all that to the target
define pmix_template_opt
	target="pmix" \
	target_ver="$(PMIX_VER)" \
	target_dep="$(pmix_dep)" \
	target_url="https://github.com/openpmix/openpmix/releases/download/v$(PMIX_VER)/pmix-$(PMIX_VER).tar.gz" \
	target_confcmd="CC=$(CC) CXX=$(CXX) FC=$(FC) F77=$(FC) ./configure --prefix=${PREFIX}" \
	target_confopt="$(pmix_opt)"
endef


#===============================================================================
.PHONY: pmix
pmix: $(pmix_dep)
ifdef PMIX_VER
	@$(pmix_template_opt) $(MAKE) --file=template.mak doit
else
	@$(pmix_template_opt) $(MAKE) --file=template.mak tit
endif

#-------------------------------------------------------------------------------
.PHONY: pmix_tar
pmix_tar: 
ifdef PMIX_VER
	@$(pmix_template_opt) $(MAKE) --file=template.mak tar
else
	@$(pmix_template_opt) $(MAKE) --file=template.mak ttar
endif

#-------------------------------------------------------------------------------
.PHONY: pmix_info
pmix_info:
ifdef PMIX_VER
	@$(pmix_template_opt) $(MAKE) --file=template.mak info
else
	@$(pmix_template_opt) $(MAKE) --file=template.mak info_none
endif

#-------------------------------------------------------------------------------
.PHONY: pmix_clean
pmix_clean: 
	@$(pmix_template_opt) $(MAKE) --file=template.mak clean

#-------------------------------------------------------------------------------
.PHONY: pmix_reallyclean
pmix_reallyclean: 
	@$(pmix_template_opt) $(MAKE) --file=template.mak reallyclean

