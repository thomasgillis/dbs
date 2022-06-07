# # build recipe for ACCFFT
#-------------------------------------------------------------------------------
# dependency list
accfft_dep = ompi fftw

accfft_opt = -DCMAKE_INSTALL_PREFIX=${PREFIX} -DBUILD_GPU=false -DCXX_FLAGS=\"-O3 -march=native\" -DBUILD_SHARED=true

ifdef FFTW_VER
accfft_opt += -DFFTW_ROOT=${PREFIX}
else
accfft_opt += -DFFTW_ROOT=${EBROOTFFTW}
endif

define accfft_template_opt
	target="accfft" \
	target_ver="$(ACCFFT_VER)" \
	target_dep="$(accfft_dep)" \
	target_url="https://github.com/amirgholami/accfft/archive/refs/heads/$(ACCFFT_VER).tar.gz" \
	target_precmd="mkdir build && cd build"\
	target_confcmd="CCMAKE_CXX_COMPILER=$(DBS_MPICXX) cmake .." \
	target_confopt="$(accfft_opt)"
endef

#===============================================================================
.PHONY: accfft
accfft: $(accfft_dep)
ifdef ACCFFT_VER
	@$(accfft_template_opt) $(MAKE) --file=template.mak doit
else
	@$(accfft_template_opt) $(MAKE) --file=template.mak tit
endif

#-------------------------------------------------------------------------------
.PHONY: accfft_tar
accfft_tar: 
ifdef ACCFFT_VER
	@$(accfft_template_opt) $(MAKE) --file=template.mak tar
else
	@$(accfft_template_opt) $(MAKE) --file=template.mak ttar
endif

#-------------------------------------------------------------------------------
.PHONY: accfft_info
accfft_info:
ifdef ACCFFT_VER
	@$(accfft_template_opt) $(MAKE) --file=template.mak info
else
	@$(accfft_template_opt) $(MAKE) --file=template.mak info_none
endif

#-------------------------------------------------------------------------------
.PHONY: accfft_clean
accfft_clean: 
	@$(accfft_template_opt) $(MAKE) --file=template.mak clean

#-------------------------------------------------------------------------------
.PHONY: accfft_reallyclean
accfft_reallyclean: 
	@$(accfft_template_opt) $(MAKE) --file=template.mak reallyclean

