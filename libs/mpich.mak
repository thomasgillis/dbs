# # build recipe for MPICH
#-------------------------------------------------------------------------------
mpich_opt ?= 
mpich_opt += --disable-fortran
#mpich_opt += --disable-cxx --disable-fortran

# get the correct libevent etc
ifdef OFI_VER
mpich_opt += --with-ofi=$(PREFIX)
else
mpich_opt ?= --with-ofi=no
endif
ifdef UCX_VER
mpich_opt += --with-ucx=$(PREFIX)
else
mpich_opt ?= --with-ucx=no
endif


#-------------------------------------------------------------------------------
# dependency list
mpich_dep = ucx ofi

define mpich_template_opt
	target="mpich" \
	target_ver="$(MPICH_VER)" \
	target_dep="$(mpich_dep)" \
	target_url="https://www.mpich.org/static/downloads/$(MPICH_VER)/mpich-$(MPICH_VER).tar.gz" \
	target_confcmd="CC=$(CC) CXX=$(CXX) ./configure --prefix=${PREFIX}" \
	target_confopt="$(mpich_opt)"
endef

#===============================================================================
ifdef MPICH_VER
DBS_MPICC = $(PREFIX)/bin/mpicc
DBS_MPICXX = $(PREFIX)/bin/mpicxx
DBS_MPIFORT = $(PREFIX)/bin/mpif90
DBS_MPIEXEC = $(PREFIX)/bin/mpiexec
else
DBS_MPICC = mpicc
DBS_MPICXX = mpic++
DBS_MPIFORT = mpif90
DBS_MPIEXEC = mpiexec
endif

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


