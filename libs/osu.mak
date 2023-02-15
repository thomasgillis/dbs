# # build recipe for osu
#-------------------------------------------------------------------------------
# dependency list
osu_dep = mpi

define osu_template_opt
	target="osu" \
	target_ver="$(OSU_VER)" \
	target_dep="$(osu_dep)" \
	target_url="https://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-$(OSU_VER).tar.gz" \
	target_confcmd="CC=$(DBS_MPICC) CXX=$(DBS_MPICXX) ./configure --prefix=${PREFIX}" \
	target_confopt="" \
	target_installcmd="$(MAKE) -j8 && make install"
endef

#===============================================================================
.PHONY: osu
osu: $(osu_dep)
ifdef OSU_VER
	@$(osu_template_opt) $(MAKE) --file=template.mak doit
else
	@$(osu_template_opt) $(MAKE) --file=template.mak tit
endif

#-------------------------------------------------------------------------------
.PHONY: osu_tar
osu_tar: 
ifdef OSU_VER
	@$(osu_template_opt) $(MAKE) --file=template.mak tar
else
	@$(osu_template_opt) $(MAKE) --file=template.mak ttar
endif

#-------------------------------------------------------------------------------
.PHONY: osu_info
osu_info:
ifdef OSU_VER
	@$(osu_template_opt) $(MAKE) --file=template.mak info
else
	@$(osu_template_opt) $(MAKE) --file=template.mak info_none
endif

#-------------------------------------------------------------------------------
.PHONY: osu_clean
osu_clean: 
	@$(osu_template_opt) $(MAKE) --file=template.mak clean

#-------------------------------------------------------------------------------
.PHONY: osu_reallyclean
osu_reallyclean: 
	@$(osu_template_opt) $(MAKE) --file=template.mak reallyclean

