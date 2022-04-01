# # build recipe for PETSC
#-------------------------------------------------------------------------------
# dependency list
petsc_dep = ompi oblas

define petsc_template_opt
	target="petsc" \
	target_ver="$(PETSC_VER)" \
	target_dep="$(petsc_dep)" \
	target_url="https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-$(PETSC_VER).tar.gz" \
	target_confcmd="./configure --prefix=${PREFIX} --with-mpi-dir=$(PREFIX) --with-openblas-dir=$(PREFIX)"
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

