# # build recipe for OMPI
#-------------------------------------------------------------------------------
ompi_opt ?= 
ompi_opt += --without-verbs --enable-mpirun-prefix-by-default --with-cuda=no ${OMPI_MISC_OPTS}

# get the correct libevent etc
# ............................
ifdef LIBEVENT_VER
ompi_opt += --with-libevent=$(PREFIX)
endif
# ............................
ifdef PMIX_VER
ompi_opt += --with-pmix=$(PREFIX)
else
OMPI_PMIX_DEP ?= --with-pmix=internal
ompi_opt += ${OMPI_PMIX_DEP}
endif
# ............................
ifdef ZLIB_VER
ompi_opt += --with-zlib=$(PREFIX)
endif
# ............................
ifdef HWLOC_VER
ompi_opt += --with-hwloc=$(PREFIX)
else
OMPI_HWLOC_DEP ?= --with-hwloc=internal
ompi_opt += ${OMPI_HWLOC_DEP}
endif
# ............................
ifdef OFI_VER
ompi_opt += --with-ofi=$(PREFIX)
#else
#OMPI_OFI_DEP ?= --with-ofi=no
#ompi_opt += ${OMPI_OFI_DEP}
endif
# ............................
ifdef UCX_VER
ompi_opt += --with-ucx=$(PREFIX)
#else
#OMPI_UCX_DEP ?= --with-ucx=no
#ompi_opt += ${OMPI_UCX_DEP}
endif

#-------------------------------------------------------------------------------
# extract the first two digits of the version
empty:=
space:=$(empty) $(empty)
ompi_ver_wordlist = $(subst .,$(space),$(OMPI_VER)) 
ompi_ver_spaced = $(wordlist 1,2,$(ompi_ver_wordlist))
ompi_ver_short = $(subst $(space),.,$(ompi_ver_spaced))

#-------------------------------------------------------------------------------
# dependency list
ompi_dep = zlib hwloc libevent pmix ucx ofi

define ompi_template_opt
	target="ompi" \
	target_ver="$(OMPI_VER)" \
	target_dep="$(ompi_dep)" \
	target_url="https://download.open-mpi.org/release/open-mpi/v$(ompi_ver_short)/openmpi-$(OMPI_VER).tar.gz" \
	target_confcmd="CC=$(CC) CXX=$(CXX) FC=$(FC) F77=$(FC) ./configure --prefix=${PREFIX}" \
	target_confopt="$(ompi_opt)"
endef

#===============================================================================
.PHONY: ompi
ompi: $(ompi_dep)
ifdef OMPI_VER
	@$(ompi_template_opt) $(MAKE) --file=template.mak doit
else
	@$(ompi_template_opt) $(MAKE) --file=template.mak tit
endif

#-------------------------------------------------------------------------------
.PHONY: ompi_tar
ompi_tar: 
ifdef OMPI_VER
	@$(ompi_template_opt) $(MAKE) --file=template.mak tar
else
	@$(ompi_template_opt) $(MAKE) --file=template.mak ttar
endif

#-------------------------------------------------------------------------------
.PHONY: ompi_info
ompi_info:
ifdef OMPI_VER
	@$(ompi_template_opt) $(MAKE) --file=template.mak info
else
	@$(ompi_template_opt) $(MAKE) --file=template.mak info_none
endif

#-------------------------------------------------------------------------------
.PHONY: ompi_clean
ompi_clean: 
	@$(ompi_template_opt) $(MAKE) --file=template.mak clean

#-------------------------------------------------------------------------------
.PHONY: ompi_reallyclean
ompi_reallyclean: 
	@$(ompi_template_opt) $(MAKE) --file=template.mak reallyclean


