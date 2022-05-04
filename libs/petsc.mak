# # build recipe for PETSC
#-------------------------------------------------------------------------------
# dependency list
petsc_dep = ompi

petsc_opt ?=

# Add hypre
ifdef HYPRE_VER
petsc_dep += hypre
petsc_opt += --with-hypre-dir=$(PREFIX)
endif

# Add oblas
ifdef OBLAS_VER
petsc_dep += oblas
petsc_opt += --with-openblas-dir=$(PREFIX)
endif

# Add ompi
ifdef OMPI_VER
petsc_opt += --with-mpi-dir=${PREFIX}
else
# we search for the full path of mpiexec and then remove the "bin/" to get the path
ifeq (, $(shell which mpiexec))
$(error "No mpiexec in $(PATH), please fix your modules or use DBS to install OMPI")
else
petsc_opt += --with-mpi-dir=$(dir $(subst bin/,,$(shell which $(DBS_MPIEXEC))))
endif
#petsc_opt += --with-cc=$(DBS_MPICC) --with-cxx=$(DBS_MPICXX) --with-mpi-f90=$(DBS_MPIFORT) --with-mpiexec=$(DBS_MPIEXEC)
endif

define petsc_template_opt
	target="petsc" \
	target_ver="$(PETSC_VER)" \
	target_dep="$(petsc_dep)" \
	target_url="https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-$(PETSC_VER).tar.gz" \
	target_confcmd="./configure --prefix=${PREFIX}"\
	target_confopt="$(petsc_opt)" \
	target_installcmd="$(MAKE) all -j8 && make install"
endef

#===============================================================================
.PHONY: petsc
petsc: $(petsc_dep)
ifdef PETSC_VER
	@$(petsc_template_opt) $(MAKE) --file=template.mak doit
else
	@$(petsc_template_opt) $(MAKE) --file=template.mak tit
endif

#-------------------------------------------------------------------------------
.PHONY: petsc_tar
petsc_tar: 
ifdef PETSC_VER
	@$(petsc_template_opt) $(MAKE) --file=template.mak tar
else
	@$(petsc_template_opt) $(MAKE) --file=template.mak ttar
endif

#-------------------------------------------------------------------------------
.PHONY: petsc_info
petsc_info:
ifdef PETSC_VER
	@$(petsc_template_opt) $(MAKE) --file=template.mak info
else
	@$(petsc_template_opt) $(MAKE) --file=template.mak info_none
endif

#-------------------------------------------------------------------------------
.PHONY: petsc_clean
petsc_clean: 
	@$(petsc_template_opt) $(MAKE) --file=template.mak clean

#-------------------------------------------------------------------------------
.PHONY: petsc_reallyclean
petsc_reallyclean: 
	@$(petsc_template_opt) $(MAKE) --file=template.mak reallyclean

