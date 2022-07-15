# # build recipe for OMPI
#-------------------------------------------------------------------------------
ompi_opt ?= 
ompi_opt += --without-verbs --enable-mpirun-prefix-by-default --with-cuda=no ${OMPI_MISC_OPTS}

# get the correct libevent etc
ifdef LIBEVENT_VER
ompi_opt += --with-libevent=$(DBS_PREFIX)
else ifdef LIBEVENT_MODDIR
ompi_opt += --with-libevent=$(LIBEVENT_MODDIR)
else
$(warning "No libevent given for OpenMPI, either install it using LIBEVENT_VER or specify a path using ")
else
endif
ifdef PMIX_VER
ompi_opt += --with-pmix=$(DBS_PREFIX)
else ifdef PMIX_MODDIR
ompi_opt += --with-pmix=$(PMIX_MODDIR)
endif
ifdef ZLIB_VER
ompi_opt += --with-zlib=$(DBS_PREFIX)
endif
ifdef HWLOC_VER
ompi_opt += --with-hwloc=$(DBS_PREFIX)
endif
ifdef OFI_VER
ompi_opt += --with-ofi=$(DBS_PREFIX)
else
ompi_opt ?= --with-ofi=no
endif
ifdef UCX_VER
ompi_opt += --with-ucx=$(DBS_PREFIX)
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
	target_confcmd="CC=$(CC) CXX=$(CXX) FC=$(FC) F77=$(FC) ./configure --prefix=${DBS_PREFIX}" \
	target_confopt="$(ompi_opt)"
endef

#===============================================================================
ifdef OMPI_VER
DBS_MPICC = $(DBS_PREFIX)/bin/mpicc
DBS_MPICXX = $(DBS_PREFIX)/bin/mpic++
DBS_MPIFORT = $(DBS_PREFIX)/bin/mpif90
DBS_MPIEXEC = $(DBS_PREFIX)/bin/mpiexec
else
DBS_MPICC = mpicc
DBS_MPICXX = mpic++
DBS_MPIFORT = mpif90
DBS_MPIEXEC = mpiexec
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


