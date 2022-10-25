# # build recipe for MPICH
#-------------------------------------------------------------------------------
mpich_opt ?= 
mpich_opt += --disable-fortran ${MPICH_MISC_OPTS}

mpich_device_list = 
# ------------  UCX ------------
ifdef UCX_VER
mpich_device_list += `ucx`
mpich_opt += --with-ucx=$(PREFIX)
else
MPICH_UCX_DEP ?= --with-ucx=no
mpich_opt += ${MPICH_UCX_DEP}
endif
# ------------  OFI ------------
ifdef OFI_VER
# .............................
ifndef UCX_VER
mpich_device_list += `ofi`
mpich_opt += --with-libfabric=$(PREFIX)
else
mpich_opt += --with-libfabric=no
$(warning OFI and UCX will not been build both with MPICH, using UCX by default)
endif
# .............................
else
MPICH_OFI_DEP ?= --with-libfabric=no
mpich_opt += ${MPICH_OFI_DEP}
endif
# ------------  PMIX ------------
ifdef PMIX_VER
mpich_opt += --with-pmi=pmix --with-pmix=$(PREFIX)
endif
# ------------  HWLOC ------------
ifdef HWLOC_VER
mpich_opt += --with-hwloc=${PREFIX}
endif
# increment the defice list
mpich_opt += --with-device=ch4:${mpich_device_list}

#-------------------------------------------------------------------------------
# dependency list
mpich_dep = ucx ofi mpix hwloc

define mpich_template_opt
	target="mpich" \
	target_ver="$(MPICH_VER)" \
	target_dep="$(mpich_dep)" \
	target_url="https://www.mpich.org/static/downloads/$(MPICH_VER)/mpich-$(MPICH_VER).tar.gz" \
	target_confcmd="CC=$(CC) CXX=$(CXX) ./configure --prefix=${PREFIX}" \
	target_confopt="$(mpich_opt)"
endef

#===============================================================================
.PHONY: mpich
mpich: $(mpich_dep)
ifdef MPICH_VER
	@$(mpich_template_opt) $(MAKE) --file=template.mak doit
else
	@$(mpich_template_opt) $(MAKE) --file=template.mak tit
endif

#-------------------------------------------------------------------------------
.PHONY: mpich_tar
mpich_tar: 
ifdef MPICH_VER
	@$(mpich_template_opt) $(MAKE) --file=template.mak tar
else
	@$(mpich_template_opt) $(MAKE) --file=template.mak ttar
endif

#-------------------------------------------------------------------------------
.PHONY: mpich_info
mpich_info:
ifdef MPICH_VER
	@$(mpich_template_opt) $(MAKE) --file=template.mak info
else
	@$(mpich_template_opt) $(MAKE) --file=template.mak info_none
endif

#-------------------------------------------------------------------------------
.PHONY: mpich_clean
mpich_clean: 
	@$(mpich_template_opt) $(MAKE) --file=template.mak clean

#-------------------------------------------------------------------------------
.PHONY: mpich_reallyclean
mpich_reallyclean: 
	@$(mpich_template_opt) $(MAKE) --file=template.mak reallyclean


