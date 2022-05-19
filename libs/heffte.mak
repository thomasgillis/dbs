# # build recipe for HEFFTE
#-------------------------------------------------------------------------------
# dependency list
heffte_dep = ompi fftw

heffte_opt = -D CMAKE_BUILD_TYPE=Release -D BUILD_SHARED_LIBS=ON -D CMAKE_INSTALL_PREFIX=${PREFIX} -D Heffte_ENABLE_AVX=ON

ifdef FFTW_VER
heffte_opt += -D Heffte_ENABLE_FFTW=ON -D FFTW_ROOT=${PREFIX}
endif

define heffte_template_opt
	target="heffte" \
	target_ver="$(HEFFTE_VER)" \
	target_dep="$(heffte_dep)" \
	target_url="https://github.com/af-ayala/heffte/archive/refs/heads/$(HEFFTE_VER).tar.gz" \
	target_precmd="mkdir build && cd build"\
	target_confcmd="CCMAKE_CXX_COMPILER=$(DBS_MPICXX) MPI_CXX_COMPILER=$(DBS_MPICXX) cmake .." \
	target_confopt="$(heffte_opt)"
endef

#===============================================================================
.PHONY: heffte
heffte: $(heffte_dep)
ifdef HEFFTE_VER
	@$(heffte_template_opt) $(MAKE) --file=template.mak doit
else
	@$(heffte_template_opt) $(MAKE) --file=template.mak tit
endif

#-------------------------------------------------------------------------------
.PHONY: heffte_tar
heffte_tar: 
ifdef HEFFTE_VER
	@$(heffte_template_opt) $(MAKE) --file=template.mak tar
else
	@$(heffte_template_opt) $(MAKE) --file=template.mak ttar
endif

#-------------------------------------------------------------------------------
.PHONY: heffte_info
heffte_info:
ifdef HEFFTE_VER
	@$(heffte_template_opt) $(MAKE) --file=template.mak info
else
	@$(heffte_template_opt) $(MAKE) --file=template.mak info_none
endif

#-------------------------------------------------------------------------------
.PHONY: heffte_clean
heffte_clean: 
	@$(heffte_template_opt) $(MAKE) --file=template.mak clean

#-------------------------------------------------------------------------------
.PHONY: heffte_reallyclean
heffte_reallyclean: 
	@$(heffte_template_opt) $(MAKE) --file=template.mak reallyclean

