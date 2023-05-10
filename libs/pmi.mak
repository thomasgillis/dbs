# # build recipe for PMI
#-------------------------------------------------------------------------------
# dependency list
pmi_dep = 
pmi_git =
pmi_repo =
pmi_opt = $(PMI_MISC_OPTS)


define pmi_template_opt
	target="pmi" \
	target_ver="$(PMI_VER)" \
	target_dep="$(pmi_dep)" \
	target_url="https://www.mpich.org/static/downloads/${PMI_VER}/libpmi-${PMI_VER}.tar.gz" \
	target_git="$(pmi_git)" \
	target_repo="$(pmi_repo)" \
	target_confcmd="CC=$(CC) CXX=$(CXX) FC=$(FC) F77=$(FC) ./configure --prefix=${PREFIX}" \
	target_confopt="$(pmi_opt)"
endef

#===============================================================================
.PHONY: pmi
pmi: $(pmi_dep)
ifdef PMI_VER
	@$(pmi_template_opt) $(MAKE) --file=template.mak doit
else
	@$(pmi_template_opt) $(MAKE) --file=template.mak tit
endif

#-------------------------------------------------------------------------------
.PHONY: pmi_tar
pmi_tar: 
ifdef PMI_VER
	@$(pmi_template_opt) $(MAKE) --file=template.mak tar
else
	@$(pmi_template_opt) $(MAKE) --file=template.mak ttar
endif

#-------------------------------------------------------------------------------
.PHONY: pmi_info
pmi_info:
ifdef PMI_VER
	@$(pmi_template_opt) $(MAKE) --file=template.mak info
else
	@$(pmi_template_opt) $(MAKE) --file=template.mak info_none
endif

#-------------------------------------------------------------------------------
.PHONY: pmi_clean
pmi_clean: 
	@$(pmi_template_opt) $(MAKE) --file=template.mak clean

#-------------------------------------------------------------------------------
.PHONY: pmi_reallyclean
pmi_reallyclean: 
	@$(pmi_template_opt) $(MAKE) --file=template.mak reallyclean


