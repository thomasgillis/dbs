# build recipe for OBLAS
#===============================================================================
# useful variables
OBLAS_DIR = OpenBLAS-$(OBLAS_VER)

#===============================================================================
.PHONY: oblas
.NOTPARALLEL: oblas
oblas: $(PREFIX)/oblas.complete

#-------------------------------------------------------------------------------
.PHONY: oblas_tar
oblas_tar: $(TAR_DIR)/oblas-$(OBLAS_VER).tar.gz 

$(TAR_DIR)/oblas-$(OBLAS_VER).tar.gz: | $(TAR_DIR)
ifdef OBLAS_VER
	cd $(TAR_DIR) && \
	wget 'https://github.com/xianyi/OpenBLAS/archive/v$(OBLAS_VER).tar.gz' &&\
	mv v$(OBLAS_VER).tar.gz oblas-$(OBLAS_VER).tar.gz
else
	touch $(TAR_DIR)/oblas-$(OBLAS_VER).tar.gz
endif

#-------------------------------------------------------------------------------
$(PREFIX)/oblas.complete: | $(PREFIX) $(TAR_DIR)/oblas-$(OBLAS_VER).tar.gz
ifdef OBLAS_VER
	mkdir -p $(COMP_DIR)  && \
	cd $(COMP_DIR) &&\
	cp $(TAR_DIR)/oblas-$(OBLAS_VER).tar.gz $(COMP_DIR) &&\
	tar -xvf v$(OBLAS_VER).tar.gz &&\
	cd $(OBLAS_DIR) &&\
	$(MAKE) USE_OPENMP=1 PREFIX=${PREFIX} -j 8 &&\
	$(MAKE) PREFIX=${PREFIX} install -j 8 &&\
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

#-------------------------------------------------------------------------------
.PHONY: oblas_reallyclean
oblas_reallyclean: 
	@rm -rf $(TAR_DIR)/oblas-$(OBLAS_VER).tar.gz
#-------------------------------------------------------------------------------
.PHONY: oblas_clean
oblas_clean: 
	@rm -rf $(PREFIX)/oblas.complete
