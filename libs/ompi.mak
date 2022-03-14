# # build recipe for OMPI
#-------------------------------------------------------------------------------
ompi_opt ?= 
ompi_opt += --without-verbs --enable-mpirun-prefix-by-default --with-cuda=no

# get the correct libevent etc
ifdef LIBEVENT_VER
ompi_opt += --with-libevent=$(PREFIX)
endif
ifdef PMIX_VER
ompi_opt += --with-pmix=$(PREFIX)
endif
ifdef ZLIB_VER
ompi_opt += --with-zlib=$(PREFIX)
endif
ifdef OFI_VER
ompi_opt += --with-ofi=$(PREFIX)
else
ompi_opt ?= --with-ofi=no
endif
ifdef UCX_VER
ompi_opt += --with-ucx=$(PREFIX)
else
ompi_opt ?= --with-ucx=no
endif


#-------------------------------------------------------------------------------
# dependency list
ompi_dep = zlib hwloc libevent pmix ucx ofi

define ompi_template_opt
	target="ompi" \
	target_ver="$(OMPI_VER)" \
	target_dep="$(ompi_dep)" \
	target_url="https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-$(OMPI_VER).tar.gz" \
	target_confcmd="CC=$(CC) CXX=$(CXX) FC=$(FC) F77=$(FC) ./configure --prefix=${PREFIX}" \
	target_confopt="$(ompi_opt)"
endef

#===============================================================================
ifdef OMPI_VER
MPICC = $(PREFIX)/bin/mpicc
MPICXX = $(PREFIX)/bin/mpic++
MPIFORT = $(PREFIX)/bin/mpif90
else
MPICC = mpicc
MPICXX = mpic++
MPIFORT = mpif90
endif

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


