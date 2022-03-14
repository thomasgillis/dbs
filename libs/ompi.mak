# # build recipe for OMPI
#-------------------------------------------------------------------------------
ompi_opt ?= 
ompi_opt += --without-verbs --enable-mpirun-prefix-by-default --with-cuda=no

# get the correct libevent etc
ifdef LIBEVENT_VER
ompi_opt += --with-libevent=$(PREFIX)
endif
ifdef PMIX_VER
ompi_opt += --with-pmix=$(PREFIX)
endif
ifdef ZLIB_VER
ompi_opt += --with-zlib=$(PREFIX)
endif
ifdef OFI_VER
ompi_opt += --with-ofi=$(PREFIX)
else
ompi_opt ?= --with-ofi=no
endif
ifdef UCX_VER
ompi_opt += --with-ucx=$(PREFIX)
else
ompi_opt ?= --with-ucx=no
endif


#-------------------------------------------------------------------------------
# dependency list
ompi_dep = zlib hwloc libevent pmix ucx ofi

define ompi_template_opt
	target="ompi" \
	target_ver="$(OMPI_VER)" \
	target_dep="$(ompi_dep)" \
	target_url="https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-$(OMPI_VER).tar.gz" \
	target_confcmd="CC=$(CC) CXX=$(CXX) FC=$(FC) F77=$(FC) ./configure --prefix=${PREFIX}" \
	target_confopt="$(ompi_opt)"
endef

#===============================================================================
ifdef OMPI_VER
MPICC = $(PREFIX)/bin/mpicc
MPICXX = $(PREFIX)/bin/mpic++
MPIFORT = $(PREFIX)/bin/mpif90
else
MPICC = mpicc
MPICXX = mpic++
MPIFORT = mpif90
endif

#===============================================================================
.PHONY: ompi
ompi: $(ompi_dep)
ifdef OMPI_VER
	@$(ompi_template_opt) $(MAKE) --file=template.mak doit
else
	@$(ompi_template_opt) $(MAKE) --file=template.mak tit
endif

#-------------------------------------------------------------------------------
.PHONY: ompi_tar
ompi_tar: 
ifdef OMPI_VER
	@$(ompi_template_opt) $(MAKE) --file=template.mak tar
else
	@$(ompi_template_opt) $(MAKE) --file=template.mak ttar
endif

#-------------------------------------------------------------------------------
.PHONY: ompi_info
ompi_info:
ifdef OMPI_VER
	@$(ompi_template_opt) $(MAKE) --file=template.mak info
else
	@$(ompi_template_opt) $(MAKE) --file=template.mak info_none
endif

#-------------------------------------------------------------------------------
.PHONY: ompi_clean
ompi_clean: 
	@$(ompi_template_opt) $(MAKE) --file=template.mak clean

#-------------------------------------------------------------------------------
.PHONY: ompi_reallyclean
ompi_reallyclean: 
	@$(ompi_template_opt) $(MAKE) --file=template.mak reallyclean


# # build recipe for OMPI
# #===============================================================================
# # useful variables
# OMPI_DIR = openmpi-$(OMPI_VER)

# #===============================================================================
# .PHONY: ompi
# ompi: zlib hwloc libevent pmix ucx ompi $(PREFIX)/ompi.complete

# #-------------------------------------------------------------------------------
# .PHONY: ompi_tar
# ompi_tar: $(TAR_DIR)/$(OMPI_DIR).tar.gz 

# $(TAR_DIR)/$(OMPI_DIR).tar.gz: | $(TAR_DIR)
# ifdef OMPI_VER
# 	cd $(TAR_DIR) &&  \
# 	wget 'https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-$(OMPI_VER).tar.gz'
# else
# 	touch $(TAR_DIR)/$(OMPI_DIR).tar.gz
# endif

# #-------------------------------------------------------------------------------
# ifdef OMPI_VER
# OMPI_OMPI_DEP = --with-ompi=$(PREFIX)
# else
# OMPI_OMPI_DEP ?= --with-ompi=no
# endif
# ifdef UCX_VER
# OMPI_UCX_DEP = --with-ucx=$(PREFIX)
# else
# OMPI_UCX_DEP ?= --with-ucx=no
# endif
# ifdef LIBEVENT_VER
# OMPI_LIBEVENT_DEP = --with-libevent=$(PREFIX)
# else
# OMPI_LIBEVENT_DEP = --with-libevent=internal
# endif
# ifdef HWLOC_VER
# OMPI_HWLOC_DEP = --with-hwloc=$(PREFIX)
# else
# OMPI_HWLOC_DEP = --with-hwloc=internal
# endif
# ifdef ZLIB_VER
# OMPI_ZLIB_DEP = --with-zlib=$(PREFIX)
# else
# OMPI_ZLIB_DEP = --with-zlib=internal
# endif
# ifdef PMIX_VER
# OMPI_PMIX_DEP = --with-pmix=$(PREFIX)
# else
# OMPI_PMIX_DEP = --with-pmix=internal
# endif

# #-------------------------------------------------------------------------------

# #-------------------------------------------------------------------------------
# $(PREFIX)/ompi.complete:  | $(PREFIX) $(TAR_DIR)/$(OMPI_DIR).tar.gz
# ifdef OMPI_VER
# 	mkdir -p $(COMP_DIR)  && \
# 	cd $(COMP_DIR)  && \
# 	cp $(TAR_DIR)/$(OMPI_DIR).tar.gz $(COMP_DIR)  && \
# 	tar -xvf $(OMPI_DIR).tar.gz  && \
# 	cd $(OMPI_DIR)  && \
# 	CC=$(CC) CXX=$(CXX) FC=$(FC) F77=$(FC) ./configure --prefix=${PREFIX} \
# 		--without-verbs --enable-mpirun-prefix-by-default --with-cuda=no \
# 		$(OMPI_OMPI_DEP) $(OMPI_UCX_DEP)   \
# 		$(OMPI_PMIX_DEP) $(OMPI_ZLIB_DEP) $(OMPI_HWLOC_DEP) $(OMPI_LIBEVENT_DEP) && \
# 	$(MAKE) install -j 8 && \
# 	date > $@  && \
# 	hostname >> $@
# else
# 	touch $(PREFIX)/ompi.complete
# endif

# #-------------------------------------------------------------------------------
# .PHONY: ompi_info
# .NOTPARALLEL: ompi_info
# ompi_info:
# ifdef OMPI_VER
# 	$(info - OMPI version: $(OMPI_VER))
# 	$(info $(space)      ompi?: $(OMPI_OMPI_DEP))
# 	$(info $(space)      ucx?: $(OMPI_UCX_DEP))
# 	$(info $(space)      pmix?: $(OMPI_PMIX_DEP))
# 	$(info $(space)      libevent?: $(OMPI_LIBEVENT_DEP)) 
# 	$(info $(space)      zlib?: $(OMPI_ZLIB_DEP))
# 	$(info $(space)      hwloc?: $(OMPI_HWLOC_DEP))
# else
# 	$(info - OMPI not built)
# endif

# #-------------------------------------------------------------------------------
# .PHONY: ompi_reallyclean
# ompi_reallyclean: 
# 	@rm -rf $(TAR_DIR)/$(OMPI_DIR).tar.gz
# #-------------------------------------------------------------------------------
# .PHONY: ompi_clean
# ompi_clean: 
# 	@rm -rf $(PREFIX)/ompi.complete


