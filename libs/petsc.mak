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
  # we search for the full path of mpiexec
  ifneq (, $(shell which mpiexec 2>/dev/null))
    # if the path is found we remove the "bin/" and store the path
    petsc_opt += --with-mpi-dir=$(dir $(subst bin/,,$(shell which $(DBS_MPIEXEC))))
  else
	# if we build petsc it's a big issue, otherwise we just add 'NOT-FOUND'
    ifeq ($(MAKECMDGOALS),petsc)
      $(error "No mpiexec in $(PATH), please fix your modules or use DBS to install OMPI")
    else
      $(warning "No mpiexec in $(PATH), please fix your modules or use DBS to install OMPI")
      petsc_opt += --with-mpi-dir=\"NOT FOUND\"
    endif
  endif
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

