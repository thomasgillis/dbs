# # build recipe for SCOREP
#-------------------------------------------------------------------------------
scorep_dep = ompi

scorep_opt ?=
scorep_opt += --with-nocross-compiler-suite=gcc
scorep_opt += --with-mpi=openmpi

ifdef PAPI_VER
scorep += papi
scorep += --with-papi-header=$(PREFIX)/include
scorep += --with-papi-lib=$(PREFIX)/lib

endif

define scorep_template_opt
	target="scorep" \
	target_ver="$(SCOREP_VER)" \
	target_dep="$(scorep_dep)" \
	target_url="https://perftools.pages.jsc.fz-juelich.de/cicd/scorep/tags/scorep-$(SCOREP_VER)/scorep-$(SCOREP_VER).tar.gz" \
	target_confcmd="CC=$(CC) CXX=$(CXX) FC=$(FC) F77=$(FC) ./configure --prefix=${PREFIX}" \
	target_confopt="$(scorep_opt)"
endef

#===============================================================================
.PHONY: scorep
scorep:
ifdef SCOREP_VER
	@$(scorep_template_opt) $(MAKE) --file=template.mak doit
else
	@$(scorep_template_opt) $(MAKE) --file=template.mak tit
endif

#===============================================================================
.PHONY: scorep_tar
scorep_tar:
ifdef SCOREP_VER
	@$(scorep_template_opt) $(MAKE) --file=template.mak tar
else
	@$(scorep_template_opt) $(MAKE) --file=template.mak ttar
endif

#-------------------------------------------------------------------------------
.PHONY: scorep_info
scorep_info:
ifdef SCOREP_VER
	@$(scorep_template_opt) $(MAKE) --file=template.mak info
else
	@$(scorep_template_opt) $(MAKE) --file=template.mak info_none
endif

#-------------------------------------------------------------------------------
.PHONY: scorep_clean
scorep_clean: 
	@$(scorep_template_opt) $(MAKE) --file=template.mak clean

#-------------------------------------------------------------------------------
.PHONY: scorep_reallyclean
scorep_reallyclean: 
	@$(scorep_template_opt) $(MAKE) --file=template.mak reallyclean

