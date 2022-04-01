# build recipe for LIBXML2
#-------------------------------------------------------------------------------
libxml2_dep = zlib

libxml2_opt ?=

ifdef ZLIB_VER
libxml2_opt += --with-zlib=$(PREFIX)
endif

define libxml2_template_opt
	target="libxml2" \
	target_ver="$(LIBXML2_VER)" \
	target_dep="$(libxml2_dep)" \
	target_url="https://gitlab.gnome.org/GNOME/libxml2/-/archive/v$(LIBXML2_VER)/libxml2-v$(LIBXML2_VER).tar.gz" \
	target_precmd="./autogen.sh" \
	target_confcmd="CC=$(CC) CXX=$(CXX) FC=$(FC) F77=$(FC) ./configure --prefix=${PREFIX}"\
	target_confopt="$(libxml2_opt)"
endef

#===============================================================================
.PHONY: libxml2
libxml2: $(libxml2_dep)
ifdef LIBXML2_VER
	@$(libxml2_template_opt) $(MAKE) --file=template.mak doit
else
	@$(libxml2_template_opt) $(MAKE) --file=template.mak tit
endif

#-------------------------------------------------------------------------------
.PHONY: libxml2_tar
libxml2_tar: 
ifdef LIBXML2_VER
	@$(libxml2_template_opt) $(MAKE) --file=template.mak tar
else
	@$(libxml2_template_opt) $(MAKE) --file=template.mak ttar
endif

#-------------------------------------------------------------------------------
.PHONY: libxml2_info
libxml2_info:
ifdef LIBXML2_VER
	@$(libxml2_template_opt) $(MAKE) --file=template.mak info
else
	@$(libxml2_template_opt) $(MAKE) --file=template.mak info_none
endif

#-------------------------------------------------------------------------------
.PHONY: libxml2_clean
libxml2_clean: 
	@$(libxml2_template_opt) $(MAKE) --file=template.mak clean

#-------------------------------------------------------------------------------
.PHONY: libxml2_reallyclean
libxml2_reallyclean: 
	@$(libxml2_template_opt) $(MAKE) --file=template.mak reallyclean


