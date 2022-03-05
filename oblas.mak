# build recipe for OBLAS
#===============================================================================
# useful variables
OBLAS_DIR = OpenBLAS-$(OBLAS_VER)

#===============================================================================
.PHONY: oblas
.NOTPARALLEL: oblas
oblas: $(PREFIX)/oblas.complete

#-------------------------------------------------------------------------------
.DELETE_ON_ERROR:
$(PREFIX)/oblas.complete: | oblas
ifdef OBLAS_VER
	cd $(COMP_DIR) ;\
	cp $(TAR_DIR)/v$(OBLAS_VER).tar.gz $(COMP_DIR) ;\
	tar -xvf v$(OBLAS_VER).tar.gz ;\
	cd $(OBLAS_DIR) ;\
	make install USE_OPENMP=1 PREFIX=${PREFIX} -j ;\
	date > $@ ;\
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
.PHONY: oblas_clean
oblas_clean: 
	@rm -rf oblas.complete
