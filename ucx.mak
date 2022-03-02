# build recipe for UCX
#===============================================================================
# get the user-defined variables
UCX_DIR ?= ucx-1.12.0

#===============================================================================
.PHONY: ucx
ucx: $(BUILD_DIR)/ucx.complete

ucx.complete:
	$(info building UCX)
	@cd $(BUILD_DIR)
	$(info get the tar $(TAR_DIR)/$(UCX_DIR))
	@cp $(TAR_DIR)/$(UCX_DIR).tar.gz $(BUILD_DIR)
	@tar -xvf $(UCX_DIR).tar.gz
	@cd $(UCX_DIR)
	$(info compile UCX)
	CC=$(CC) CXX=$(CXX) FC=$(FC) F77=$(FC) ./configure --prefix=${PREFIX} --enable-compiler-opt=3
	$(info install UCX to $(PREFIX))
	make install -j
	$(info write the complete file)
	@cd $(BUILD_DIR)
	date > ucx.complete
	hostname >> ucx.complete

.PHONY: ucx_info
.NOTPARALLEL: ucx_info
	
ucx_info:
	$(info --------------------------------------------------------------------------------)
	$(info UCX)
	$(info - dir: $(UCX_DIR))

.PHONY: ucx_clean
ucx_clean: 
	@rm -rf ucx.complete
