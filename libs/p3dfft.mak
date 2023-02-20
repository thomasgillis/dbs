# # build recipe for P3DFFT
#-------------------------------------------------------------------------------
# dependency list
p3dfft_dep = fftw mpi
p3dfft_opt =  

ifdef FFTW_VER
p3dfft_opt += --enable-fftw --with-fftw=${PREFIX}
else
p3dfft_opt += --enable-fftw --with-fftw=${EBROOTFFTW}
endif

define p3dfft_template_opt
	target="p3dfft" \
	target_ver="$(P3DFFT_VER)" \
	target_dep="$(p3dfft_dep)" \
	target_url="https://github.com/sdsc/p3dfft.3/archive/refs/tags/v.$(P3DFFT_VER).tar.gz" \
	target_precmd="sed -i 's/MPI_REAL/MPI_FLOAT/g' build/exec.C"\
	target_confcmd="CXX=$(DBS_MPICXX) CC=$(DBS_MPICC) CXXFLAGS=\"-g -O3 -std=c++17\" FC=$(DBS_MPIFORT) F77=$(DBS_MPIFORT) ./configure --prefix=${PREFIX}" \
	target_confopt="--enable-gnu $(p3dfft_opt)"
endef

#===============================================================================
.PHONY: p3dfft
p3dfft: $(p3dfft_dep)
ifdef P3DFFT_VER
	@$(p3dfft_template_opt) $(MAKE) --file=template.mak doit
else
	@$(p3dfft_template_opt) $(MAKE) --file=template.mak tit
endif

#-------------------------------------------------------------------------------
.PHONY: p3dfft_tar
p3dfft_tar: 
ifdef P3DFFT_VER
	@$(p3dfft_template_opt) $(MAKE) --file=template.mak tar
else
	@$(p3dfft_template_opt) $(MAKE) --file=template.mak ttar
endif

#-------------------------------------------------------------------------------
.PHONY: p3dfft_info
p3dfft_info:
ifdef P3DFFT_VER
	@$(p3dfft_template_opt) $(MAKE) --file=template.mak info
else
	@$(p3dfft_template_opt) $(MAKE) --file=template.mak info_none
endif

#-------------------------------------------------------------------------------
.PHONY: p3dfft_clean
p3dfft_clean: 
	@$(p3dfft_template_opt) $(MAKE) --file=template.mak clean

#-------------------------------------------------------------------------------
.PHONY: p3dfft_reallyclean
p3dfft_reallyclean: 
	@$(p3dfft_template_opt) $(MAKE) --file=template.mak reallyclean

