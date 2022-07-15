# # build recipe for FFTW
#-------------------------------------------------------------------------------
# dependency list
fftw_dep = ompi

define fftw_template_opt
	target="fftw" \
	target_ver="$(FFTW_VER)" \
	target_dep="$(fftw_dep)" \
	target_url="http://www.fftw.org/fftw-${FFTW_VER}.tar.gz" \
	target_confcmd="CC=$(DBS_MPICC) CXX=$(DBS_MPICXX) FC=$(DBS_MPIFORT) F77=$(DBS_MPIFORT) ./configure --prefix=${DBS_PREFIX}" \
	target_confopt="--enable-shared --enable-mpi --disable-fortran --enable-openmp"
endef

#===============================================================================
.PHONY: fftw
fftw: $(fftw_dep)
ifdef FFTW_VER
	@$(fftw_template_opt) $(MAKE) --file=template.mak doit
else
	@$(fftw_template_opt) $(MAKE) --file=template.mak tit
endif

#-------------------------------------------------------------------------------
.PHONY: fftw_tar
fftw_tar: 
ifdef FFTW_VER
	@$(fftw_template_opt) $(MAKE) --file=template.mak tar
else
	@$(fftw_template_opt) $(MAKE) --file=template.mak ttar
endif

#-------------------------------------------------------------------------------
.PHONY: fftw_info
fftw_info:
ifdef FFTW_VER
	@$(fftw_template_opt) $(MAKE) --file=template.mak info
else
	@$(fftw_template_opt) $(MAKE) --file=template.mak info_none
endif

#-------------------------------------------------------------------------------
.PHONY: fftw_clean
fftw_clean: 
	@$(fftw_template_opt) $(MAKE) --file=template.mak clean

#-------------------------------------------------------------------------------
.PHONY: fftw_reallyclean
fftw_reallyclean: 
	@$(fftw_template_opt) $(MAKE) --file=template.mak reallyclean

