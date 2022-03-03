# build recipe for OBLAS
#===============================================================================
# useful variables
OBLAS_DIR = OpenBLAS-$(OBLAS_VER)

#===============================================================================
.PHONY: oblas
.NOTPARALLEL: oblas
oblas: $(COMP_DIR)/oblas.complete

#-------------------------------------------------------------------------------
$(COMP_DIR)/oblas.complete: make_dir
ifdef OBLAS_VER
	cd $(COMP_DIR) ;\
	cp $(TAR_DIR)/v$(OBLAS_VER).tar.gz $(COMP_DIR) ;\
	tar -xvf v$(OBLAS_VER).tar.gz ;\
	cd $(OBLAS_DIR) ;\
	make install USE_OPENMP=1 PREFIX=${PREFIX} -j ;\
	cd $(COMP_DIR) ;\
	date > oblas.complete ;\
	hostname >> oblas.complete
else
	touch $(COMP_DIR)/oblas.complete
endif

#-------------------------------------------------------------------------------
.PHONY: oblas_info
.NOTPARALLEL: oblas_info
oblas_info:
	$(info --------------------------------------------------------------------------------)
	$(info OBLAS)
ifdef OBLAS_VER
	$(info - version: $(OBLAS_VER))
else
	$(info not built)
endif
	$(info )

#-------------------------------------------------------------------------------
.PHONY: oblas_clean
oblas_clean: 
	@rm -rf oblas.complete
