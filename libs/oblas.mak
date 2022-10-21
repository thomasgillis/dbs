# # build recipe for OBLAS
#-------------------------------------------------------------------------------
oblas_dep = 

define oblas_template_opt
	target="oblas" \
	target_ver="$(OBLAS_VER)" \
	target_dep="$(oblas_dep)" \
	target_url="https://github.com/xianyi/OpenBLAS/archive/v$(OBLAS_VER).tar.gz" \
	target_confcmd="$(MAKE) USE_OPENMP=1 NO_FORTRAN=1 PREFIX=${PREFIX} -j8" \
	target_installcmd="$(MAKE) PREFIX=${PREFIX} install -j8"
endef

#===============================================================================
.PHONY: oblas
oblas:
ifdef OBLAS_VER
	@$(oblas_template_opt) $(MAKE) --file=template.mak doit
else
	@$(oblas_template_opt) $(MAKE) --file=template.mak tit
endif

#===============================================================================
.PHONY: oblas_tar
oblas_tar:
ifdef OBLAS_VER
	@$(oblas_template_opt) $(MAKE) --file=template.mak tar
else
	@$(oblas_template_opt) $(MAKE) --file=template.mak ttar
endif

#-------------------------------------------------------------------------------
.PHONY: oblas_info
oblas_info:
ifdef OBLAS_VER
	@$(oblas_template_opt) $(MAKE) --file=template.mak info
else
	@$(oblas_template_opt) $(MAKE) --file=template.mak info_none
endif

#-------------------------------------------------------------------------------
.PHONY: oblas_clean
oblas_clean: 
	@$(oblas_template_opt) $(MAKE) --file=template.mak clean

#-------------------------------------------------------------------------------
.PHONY: oblas_reallyclean
oblas_reallyclean: 
	@$(oblas_template_opt) $(MAKE) --file=template.mak reallyclean

