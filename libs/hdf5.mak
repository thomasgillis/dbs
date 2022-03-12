# # build recipe for HDF5
#-------------------------------------------------------------------------------
# dependency list
hdf5_dep = ompi zlib

define hdf5_template_opt
	target="hdf5" \
	target_ver="$(HDF5_VER)" \
	target_dep="$(hdf5_dep)" \
	target_url="http://www.hdfgroup.org/ftp/HDF5/releases/hdf5-1.12/hdf5-$(HDF5_VER)/src/hdf5-$(HDF5_VER).tar.bz2" \
	target_confcmd="CC=$(CC) CXX=$(CXX) FC=$(FC) F77=$(FC) ./configure --prefix=${PREFIX}" \
	target_confopt="--enable-parallel --enable-optimization=high --enable-build-mode=production --with-default-api-version=v110"
endef

#===============================================================================
.PHONY: hdf5
hdf5: $(hdf5_dep)
ifdef HDF5_VER
	@$(hdf5_template_opt) $(MAKE) --file=template.mak doit
else
	@$(hdf5_template_opt) $(MAKE) --file=template.mak tit
endif

#-------------------------------------------------------------------------------
.PHONY: hdf5_tar
hdf5_tar: 
ifdef ZLIB_VER
	@$(hdf5_template_opt) $(MAKE) --file=template.mak tar
else
	@$(hdf5_template_opt) $(MAKE) --file=template.mak ttar
endif

#-------------------------------------------------------------------------------
.PHONY: hdf5_info
hdf5_info:
ifdef HDF5_VER
	@$(hdf5_template_opt) $(MAKE) --file=template.mak info
else
	@$(hdf5_template_opt) $(MAKE) --file=template.mak info_none
endif

#-------------------------------------------------------------------------------
.PHONY: hdf5_clean
hdf5_clean: 
	@$(hdf5_template_opt) $(MAKE) --file=template.mak clean

#-------------------------------------------------------------------------------
.PHONY: hdf5_reallyclean
hdf5_reallyclean: 
	@$(hdf5_template_opt) $(MAKE) --file=template.mak reallyclean

# # build recipe for HDF5
# #===============================================================================
# # useful variables
# HDF5_DIR = hdf5-$(HDF5_VER)

# #===============================================================================
# .PHONY: hdf5
# .NOTPARALLEL: hdf5
# hdf5: ompi $(PREFIX)/hdf5.complete

# #-------------------------------------------------------------------------------
# .PHONY: hdf5tar
# hdf5_tar: $(TAR_DIR)/$(HDF5_DIR).tar.bz2

# $(TAR_DIR)/$(HDF5_DIR).tar.bz2: | $(TAR_DIR)
# ifdef HDF5_VER
# 	cd $(TAR_DIR) &&  \
# 	wget 'http://www.hdfgroup.org/ftp/HDF5/releases/hdf5-1.12/hdf5-$(HDF5_VER)/src/hdf5-$(HDF5_VER).tar.bz2'
# else
# 	touch $(TAR_DIR)/$(HDF5_DIR).tar.bz2
# endif

# #-------------------------------------------------------------------------------
# $(PREFIX)/hdf5.complete:  | $(PREFIX) $(TAR_DIR)/$(HDF5_DIR).tar.bz2
# ifdef HDF5_VER
# 	mkdir -p $(COMP_DIR)  && \
# 	cd $(COMP_DIR)  &&\
# 	cp $(TAR_DIR)/$(HDF5_DIR).tar.bz2 $(COMP_DIR)  &&\
# 	tar -xvf $(HDF5_DIR).tar.bz2  &&\
# 	cd $(HDF5_DIR)  &&\
# 	CC=$(MPICC) CXX=$(MPICXX) FC=$(MPIFORT) F77=$(MPIFORT) ./configure --prefix=${PREFIX} \
# 	   --enable-parallel --enable-optimization=high --enable-build-mode=production --with-default-api-version=v110  &&\
# 	$(MAKE) install -j 8 &&\
# 	date > $@  &&\
# 	hostname >> $@
# else
# 	touch $(PREFIX)/hdf5.complete
# endif

# #-------------------------------------------------------------------------------
# .PHONY: hdf5_info
# .NOTPARALLEL: hdf5_info
# hdf5_info:
# ifdef HDF5_VER
# 	$(info - HDF5 version: $(HDF5_VER))
# else
# 	$(info - HDF5 not built)
# endif

# #-------------------------------------------------------------------------------
# .PHONY: hdf5_reallyclean
# hdf5_reallyclean: 
# 	@rm -rf $(TAR_DIR)/$(HDF5_DIR).tar.bz2
# #-------------------------------------------------------------------------------
# .PHONY: hdf5_clean
# hdf5_clean: 
# 	@rm -rf $(PREFIX)/hdf5.complete
