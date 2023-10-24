# # build recipe for FFTW
#-------------------------------------------------------------------------------
# dependency list
fftw_dep = mpi

define fftw_template_opt_double
	target="fftw_double" \
	target_ver="$(FFTW_VER)" \
	target_dep="$(fftw_dep)" \
	target_url="http://www.fftw.org/fftw-${FFTW_VER}.tar.gz" \
	target_confcmd="CC=$(DBS_MPICC) CXX=$(DBS_MPICXX) FC=$(DBS_MPIFORT) F77=$(DBS_MPIFORT) ./configure --prefix=${PREFIX}" \
	target_confopt="--enable-shared --enable-mpi --enable-fortran --enable-openmp"
endef
define fftw_template_opt_single
	target="fftw_single" \
	target_ver="$(FFTW_VER)" \
	target_dep="$(fftw_dep)" \
	target_url="http://www.fftw.org/fftw-${FFTW_VER}.tar.gz" \
	target_confcmd="CC=$(DBS_MPICC) CXX=$(DBS_MPICXX) FC=$(DBS_MPIFORT) F77=$(DBS_MPIFORT) ./configure --prefix=${PREFIX}" \
	target_confopt="--enable-shared --enable-mpi --enable-fortran --enable-openmp --enable-float"
endef
define fftw_template_opt
	target="fftw"
endef

versions = double single

#===============================================================================
# the main formulat just touches fftw.complete
.PHONY: fftw
fftw: $(fftw_dep) $(foreach ver,$(versions),fftw_$(ver))
	@$(fftw_template_opt) $(MAKE) --file=template.mak tit

# double precision
.PHONY: fftw_double
fftw_double: $(fftw_dep)
ifdef FFTW_VER
	@$(fftw_template_opt_double) $(MAKE) --file=template.mak doit
else
	@$(fftw_template_opt_double) $(MAKE) --file=template.mak tit
endif

# single precision
.PHONY: fftw_single
fftw_single: $(fftw_dep)
ifdef FFTW_VER
	@$(fftw_template_opt_single) $(MAKE) --file=template.mak doit
else
	@$(fftw_template_opt_single) $(MAKE) --file=template.mak tit
endif

#-------------------------------------------------------------------------------
.PHONY: fftw_tar
fftw_tar: $(foreach ver,$(versions),fftw_tar_$(ver))
	@$(fftw_template_opt) $(MAKE) --file=template.mak ttar

.PHONY: fftw_tar_double
fftw_tar_double:
ifdef FFTW_VER
	@$(fftw_template_opt_double) $(MAKE) --file=template.mak tar
else
	@$(fftw_template_opt_double) $(MAKE) --file=template.mak ttar
endif

.PHONY: fftw_tar_single
fftw_tar_single: 
ifdef FFTW_VER
	@$(fftw_template_opt_single) $(MAKE) --file=template.mak tar
else
	@$(fftw_template_opt_single) $(MAKE) --file=template.mak ttar
endif
#-------------------------------------------------------------------------------
.PHONY: fftw_info
fftw_info:
ifdef FFTW_VER
	@$(fftw_template_opt_double) $(MAKE) --file=template.mak info
	@$(fftw_template_opt_single) $(MAKE) --file=template.mak info
else
	@$(fftw_template_opt) $(MAKE) --file=template.mak info_none
endif

#-------------------------------------------------------------------------------
.PHONY: fftw_clean
fftw_clean: 
	@$(fftw_template_opt_double) $(MAKE) --file=template.mak clean
	@$(fftw_template_opt_single) $(MAKE) --file=template.mak clean
	@$(fftw_template_opt) $(MAKE) --file=template.mak clean

#-------------------------------------------------------------------------------
.PHONY: fftw_reallyclean
fftw_reallyclean: 
	@$(fftw_template_opt) $(MAKE) --file=template.mak reallyclean

