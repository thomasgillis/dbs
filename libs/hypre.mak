# # build recipe for HYPRE
#-------------------------------------------------------------------------------
# dependency list
hypre_dep = ompi
hypre_opt ?=

ifdef OBLAS_VER
hypre_dep += oblas
hypre_opt += --with-blas-lib=\"-L$(PREFIX)/lib -lopenblas\" --with-lapack-lib=\"-L$(PREFIX)/lib -lopenblas\"
endif

define hypre_template_opt
	target="hypre" \
	target_ver="$(HYPRE_VER)" \
	target_dep="$(hypre_dep)" \
	target_url="https://github.com/hypre-space/hypre/archive/refs/tags/v$(HYPRE_VER).tar.gz" \
	target_precmd="cd src" \
	target_confcmd="CC=$(DBS_MPICC) CXX=$(DBS_MPICXX) ./configure --prefix=${PREFIX}" \
	target_confopt="$(hypre_opt)"
endef

#===============================================================================
.PHONY: hypre
hypre: $(hypre_dep)
ifdef HYPRE_VER
	@$(hypre_template_opt) $(MAKE) --file=template.mak doit
else
	@$(hypre_template_opt) $(MAKE) --file=template.mak tit
endif

#-------------------------------------------------------------------------------
.PHONY: hypre_tar
hypre_tar: 
ifdef HYPRE_VER
	@$(hypre_template_opt) $(MAKE) --file=template.mak tar
else
	@$(hypre_template_opt) $(MAKE) --file=template.mak ttar
endif

#-------------------------------------------------------------------------------
.PHONY: hypre_info
hypre_info:
ifdef HYPRE_VER
	@$(hypre_template_opt) $(MAKE) --file=template.mak info
else
	@$(hypre_template_opt) $(MAKE) --file=template.mak info_none
endif

#-------------------------------------------------------------------------------
.PHONY: hypre_clean
hypre_clean: 
	@$(hypre_template_opt) $(MAKE) --file=template.mak clean

#-------------------------------------------------------------------------------
.PHONY: hypre_reallyclean
hypre_reallyclean: 
	@$(hypre_template_opt) $(MAKE) --file=template.mak reallyclean

