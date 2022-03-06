# build recipe for OBLAS
#===============================================================================
# useful variables
OBLAS_DIR = OpenBLAS-$(OBLAS_VER)

#===============================================================================
.PHONY: oblas
.NOTPARALLEL: oblas
oblas: $(PREFIX)/oblas.complete

#-------------------------------------------------------------------------------
oblas_tar: $(TAR_DIR)/v$(OBLAS_VER).tar.gz 

$(TAR_DIR)/v$(OBLAS_VER).tar.gz: | $(TAR_DIR)
ifdef OBLAS_VER
	cd $(TAR_DIR) && \
	wget 'https://github.com/xianyi/OpenBLAS/archive/v$(OBLAS_VER).tar.gz'
else
	touch $(TAR_DIR)/v$(OBLAS_VER).tar.gz
endif

#-------------------------------------------------------------------------------
.DELETE_ON_ERROR:
$(PREFIX)/oblas.complete: | $(PREFIX) $(COMP_DIR) $(TAR_DIR)/v$(OBLAS_VER).tar.gz
ifdef OBLAS_VER
	cd $(COMP_DIR) &&\
	cp $(TAR_DIR)/v$(OBLAS_VER).tar.gz $(COMP_DIR) &&\
	tar -xvf v$(OBLAS_VER).tar.gz &&\
	cd $(OBLAS_DIR) &&\
	$(MAKE) USE_OPENMP=1 PREFIX=${PREFIX} -j &&\
	$(MAKE) install -j &&\
	date > $@ &&\
	hostname >> $@
else
	touch $(PREFIX)/oblas.complete
endif

#-------------------------------------------------------------------------------
.PHONY: oblas_info
.NOTPARALLEL: oblas_info
oblas_info:
ifdef OBLAS_VER
	$(info - OpenBlas version: $(OBLAS_VER))
else
	$(info - OpenBlas not built)
endif
	$(info )

#-------------------------------------------------------------------------------
.PHONY: oblas_reallyclean
oblas_reallyclean: 
	@rm -rf $(TAR_DIR)/v$(OBLAS_VER).tar.gz
#-------------------------------------------------------------------------------
.PHONY: oblas_clean
oblas_clean: 
	@rm -rf oblas.complete
