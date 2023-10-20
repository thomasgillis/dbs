# # build recipe for METIS
#-------------------------------------------------------------------------------
# dependency list
metis_dep = gklib
metis_git =
metis_repo =
metis_opt = $(METIS_MISC_OPTS)


define metis_template_opt
	target="metis" \
	target_ver="$(METIS_VER)" \
	target_dep="$(metis_dep)" \
	target_url="https://github.com/KarypisLab/METIS/archive/refs/tags/v$(METIS_VER).tar.gz" \
	target_git="$(metis_git)" \
	target_repo="$(metis_repo)" \
	target_confcmd="$(MAKE) config cc=$(DBS_MPICC) prefix=${PREFIX}"
endef

#===============================================================================
.PHONY: metis
metis: $(metis_dep)
ifdef METIS_VER
	@$(metis_template_opt) $(MAKE) --file=template.mak doit
else
	@$(metis_template_opt) $(MAKE) --file=template.mak tit
endif

#-------------------------------------------------------------------------------
.PHONY: metis_tar
metis_tar: 
ifdef METIS_VER
	@$(metis_template_opt) $(MAKE) --file=template.mak tar
else
	@$(metis_template_opt) $(MAKE) --file=template.mak ttar
endif

#-------------------------------------------------------------------------------
.PHONY: metis_info
metis_info:
ifdef METIS_VER
	@$(metis_template_opt) $(MAKE) --file=template.mak info
else
	@$(metis_template_opt) $(MAKE) --file=template.mak info_none
endif

#-------------------------------------------------------------------------------
.PHONY: metis_clean
metis_clean: 
	@$(metis_template_opt) $(MAKE) --file=template.mak clean

#-------------------------------------------------------------------------------
.PHONY: metis_reallyclean
metis_reallyclean: 
	@$(metis_template_opt) $(MAKE) --file=template.mak reallyclean


