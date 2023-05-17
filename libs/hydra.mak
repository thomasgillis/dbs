# # build recipe for HYDRA
#-------------------------------------------------------------------------------
# dependency list
hydra_dep = 
hydra_git =
hydra_repo =
hydra_opt = $(HYDRA_MISC_OPTS)


define hydra_template_opt
	target="hydra" \
	target_ver="$(HYDRA_VER)" \
	target_dep="$(hydra_dep)" \
	target_url="https://www.mpich.org/static/downloads/${HYDRA_VER}/hydra-${HYDRA_VER}.tar.gz" \
	target_git="$(hydra_git)" \
	target_repo="$(hydra_repo)" \
	target_confcmd="CC=$(CC) CXX=$(CXX) FC=$(FC) F77=$(FC) ./configure --prefix=${PREFIX}" \
	target_confopt="$(hydra_opt)"
endef

#===============================================================================
.PHONY: hydra
hydra: $(pmi_dep)
ifdef HYDRA_VER
	@$(hydra_template_opt) $(MAKE) --file=template.mak doit
else
	@$(hydra_template_opt) $(MAKE) --file=template.mak tit
endif

#-------------------------------------------------------------------------------
.PHONY: hydra_tar
hydra_tar: 
ifdef HYDRA_VER
	@$(hydra_template_opt) $(MAKE) --file=template.mak tar
else
	@$(hydra_template_opt) $(MAKE) --file=template.mak ttar
endif

#-------------------------------------------------------------------------------
.PHONY: hydra_info
hydra_info:
ifdef HYDRA_VER
	@$(hydra_template_opt) $(MAKE) --file=template.mak info
else
	@$(hydra_template_opt) $(MAKE) --file=template.mak info_none
endif

#-------------------------------------------------------------------------------
.PHONY: hydra_clean
hydra_clean: 
	@$(hydra_template_opt) $(MAKE) --file=template.mak clean

#-------------------------------------------------------------------------------
.PHONY: hydra_reallyclean
hydra_reallyclean: 
	@$(hydra_template_opt) $(MAKE) --file=template.mak reallyclean


