# # build recipe for P4EST
#-------------------------------------------------------------------------------
# dependency list
p4est_dep = ompi oblas

define p4est_template_opt
	target="p4est" \
	target_ver="$(P4EST_VER)" \
	target_dep="$(p4est_dep)" \
	target_url="https://p4est.github.io/release/p4est-$(P4EST_VER).tar.gz" \
	target_confcmd="CC=$(DBS_MPICC) CXX=$(DBS_MPICXX) FC=$(DBS_MPIFORT) F77=$(DBS_MPIFORT) ./configure --prefix=${DBS_PREFIX}" \
	target_confopt="--enable-mpi --enable-openmp --with-blas=-lopenblas"
endef

#===============================================================================
.PHONY: p4est
p4est: $(p4est_dep)
ifdef P4EST_VER
	@$(p4est_template_opt) $(MAKE) --file=template.mak doit
else
	@$(p4est_template_opt) $(MAKE) --file=template.mak tit
endif

#-------------------------------------------------------------------------------
.PHONY: p4est_tar
p4est_tar: 
ifdef P4EST_VER
	@$(p4est_template_opt) $(MAKE) --file=template.mak tar
else
	@$(p4est_template_opt) $(MAKE) --file=template.mak ttar
endif

#-------------------------------------------------------------------------------
.PHONY: p4est_info
p4est_info:
ifdef P4EST_VER
	@$(p4est_template_opt) $(MAKE) --file=template.mak info
else
	@$(p4est_template_opt) $(MAKE) --file=template.mak info_none
endif

#-------------------------------------------------------------------------------
.PHONY: p4est_clean
p4est_clean: 
	@$(p4est_template_opt) $(MAKE) --file=template.mak clean

#-------------------------------------------------------------------------------
.PHONY: p4est_reallyclean
p4est_reallyclean: 
	@$(p4est_template_opt) $(MAKE) --file=template.mak reallyclean

