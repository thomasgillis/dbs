# # build recipe for HWLOC
#-------------------------------------------------------------------------------
hwloc_dep = libxml2

# options from https://github.com/easybuilders/easybuild-easyconfigs/blob/develop/easybuild/easyconfigs/h/hwloc
hwloc_opt ?= --disable-cairo --disable-opencl --disable-cuda --disable-nvml --disable-gl --disable-libudev 
hwloc_preopt ?=

ifdef LIBXML2_VER
hwloc_preopt += HWLOC_LIBXML2_CFLAGS=\"-I$(DBS_PREFIX)/include/libxml2\" HWLOC_LIBXML2_LIBS=\"-L$(DBS_PREFIX)/lib -lz\"
endif

define hwloc_template_opt
	target="hwloc" \
	target_ver="$(HWLOC_VER)" \
	target_dep="$(hwloc_dep)" \
	target_url="https://download.open-mpi.org/release/hwloc/v2.7/hwloc-$(HWLOC_VER).tar.gz" \
	target_confcmd="CC=$(CC) CXX=$(CXX) FC=$(FC) F77=$(FC) $(hwloc_preopt) ./configure --prefix=${DBS_PREFIX}" \
	target_confopt="$(hwloc_opt)"
endef

#===============================================================================
.PHONY: hwloc
hwloc: $(hwloc_dep)
ifdef HWLOC_VER
	@$(hwloc_template_opt) $(MAKE) --file=template.mak doit
else
	@$(hwloc_template_opt) $(MAKE) --file=template.mak tit
endif

#===============================================================================
.PHONY: hwloc_tar
hwloc_tar:
ifdef HWLOC_VER
	@$(hwloc_template_opt) $(MAKE) --file=template.mak tar
else
	@$(hwloc_template_opt) $(MAKE) --file=template.mak ttar
endif

#-------------------------------------------------------------------------------
.PHONY: hwloc_info
hwloc_info:
ifdef HWLOC_VER
	@$(hwloc_template_opt) $(MAKE) --file=template.mak info
else
	@$(hwloc_template_opt) $(MAKE) --file=template.mak info_none
endif

#-------------------------------------------------------------------------------
.PHONY: hwloc_clean
hwloc_clean: 
	@$(hwloc_template_opt) $(MAKE) --file=template.mak clean

#-------------------------------------------------------------------------------
.PHONY: hwloc_reallyclean
hwloc_reallyclean: 
	@$(hwloc_template_opt) $(MAKE) --file=template.mak reallyclean

