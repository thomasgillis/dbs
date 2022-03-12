# # build recipe for P4EST
#-------------------------------------------------------------------------------
# dependency list
p4est_dep = ompi oblas

define p4est_template_opt
	target="p4est" \
	target_ver="$(P4EST_VER)" \
	target_dep="$(p4est_dep)" \
	target_url="https://p4est.github.io/release/p4est-$(P4EST_VER).tar.gz" \
	target_confcmd="CC=$(CC) CXX=$(CXX) FC=$(FC) F77=$(FC) ./configure --prefix=${PREFIX}" \
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
ifdef ZLIB_VER
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


# # build recipe for P4EST
# #===============================================================================
# # useful variables
# P4EST_DIR = p4est-$(P4EST_VER)

# #===============================================================================
# .PHONY: p4est
# .NOTPARALLEL: p4est
# p4est: ompi oblas $(PREFIX)/p4est.complete

# #-------------------------------------------------------------------------------
# .PHONY: p4est_test
# p4est_tar: $(TAR_DIR)/$(P4EST_DIR).tar.gz

# $(TAR_DIR)/$(P4EST_DIR).tar.gz: | $(TAR_DIR)
# ifdef P4EST_VER
# 	cd $(TAR_DIR) &&  \
# 	wget 'https://p4est.github.io/release/p4est-$(P4EST_VER).tar.gz'
# else
# 	touch $(TAR_DIR)/$(P4EST_DIR).tar.gz
# endif

# #-------------------------------------------------------------------------------
# $(PREFIX)/p4est.complete:  | $(PREFIX) $(TAR_DIR)/$(P4EST_DIR).tar.gz
# ifdef P4EST_VER
# 	mkdir -p $(COMP_DIR)  && \
# 	cd $(COMP_DIR)  && \
# 	cp $(TAR_DIR)/$(P4EST_DIR).tar.gz $(COMP_DIR)  && \
# 	tar -xvf $(P4EST_DIR).tar.gz  && \
# 	cd $(P4EST_DIR)  && \
# 	CC=$(MPICC) CXX=$(MPICXX) FC=$(MPIFORT) F77=$(MPIFORT) ./configure --prefix=${PREFIX} \
# 	   --enable-mpi --enable-openmp --with-blas=-lopenblas  && \
# 	$(MAKE) install -j 8 && \
# 	date > $@  && \
# 	hostname >> $@
# else
# 	touch $(PREFIX)/p4est.complete
# endif

# #-------------------------------------------------------------------------------
# .PHONY: p4est_info
# .NOTPARALLEL: p4est_info
# p4est_info:
# ifdef P4EST_VER
# 	$(info - P4EST version: $(P4EST_VER))
# else
# 	$(info - P4EST not built)
# endif

# #-------------------------------------------------------------------------------
# .PHONY: p4est_reallyclean
# p4est_reallyclean: 
# 	@rm -rf $(TAR_DIR)/$(P4EST_DIR).tar.gz
# #-------------------------------------------------------------------------------
# .PHONY: p4est_clean
# p4est_clean: 
# 	@rm -rf $(PREFIX)/p4est.complete
