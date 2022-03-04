# build recipe for OBLAS
#===============================================================================
# useful variables
OBLAS_DIR = OpenBLAS-$(OBLAS_VER)

#===============================================================================
.PHONY: oblas
.NOTPARALLEL: oblas
oblas: $(PREFIX)/oblas.complete

COMP_DIR := $(BUILD_DIR)/tmp-ucx-$(TAG)-$(UID)

#-------------------------------------------------------------------------------
$(PREFIX)/oblas.complete:
ifdef OBLAS_VER
	mkdir -p $(COMP_DIR) ;\
	cd $(COMP_DIR) ;\
	cp $(TAR_DIR)/v$(OBLAS_VER).tar.gz $(COMP_DIR) ;\
	tar -xvf v$(OBLAS_VER).tar.gz ;\
	cd $(OBLAS_DIR) ;\
	make install USE_OPENMP=1 PREFIX=${PREFIX} -j ;\
	date > $(PREFIX)/oblas.complete ;\
	hostname >> $(PREFIX)/oblas.complete
else
	touch $(PREFIX)/oblas.complete
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
