# build recipe for ZLIB
#-------------------------------------------------------------------------------
zlib_dep = 

define zlib_template_opt
	target="zlib" \
	target_ver="$(ZLIB_VER)" \
	target_dep="$(zlib_dep)" \
	target_url="https://zlib.net/zlib-$(ZLIB_VER).tar.gz" \
	target_confcmd="CC=$(CC) CXX=$(CXX) FC=$(FC) F77=$(FC) CFLAGS=-fPIC ./configure --DBS_PREFIX=${DBS_PREFIX}"
endef

#===============================================================================
.PHONY: zlib
zlib: $(zlib_dep)
ifdef ZLIB_VER
	@$(zlib_template_opt) $(MAKE) --file=template.mak doit
else
	@$(zlib_template_opt) $(MAKE) --file=template.mak tit
endif

#-------------------------------------------------------------------------------
.PHONY: zlib_tar
zlib_tar: 
ifdef ZLIB_VER
	@$(zlib_template_opt) $(MAKE) --file=template.mak tar
else
	@$(zlib_template_opt) $(MAKE) --file=template.mak ttar
endif

#-------------------------------------------------------------------------------
.PHONY: zlib_info
zlib_info:
ifdef ZLIB_VER
	@$(zlib_template_opt) $(MAKE) --file=template.mak info
else
	@$(zlib_template_opt) $(MAKE) --file=template.mak info_none
endif

#-------------------------------------------------------------------------------
.PHONY: zlib_clean
zlib_clean: 
	@$(zlib_template_opt) $(MAKE) --file=template.mak clean

#-------------------------------------------------------------------------------
.PHONY: zlib_reallyclean
zlib_reallyclean: 
	@$(zlib_template_opt) $(MAKE) --file=template.mak reallyclean


