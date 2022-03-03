# build recipe for UCX
#===============================================================================
# get the user-defined variables
UCX_VER ?= 1.12.0

#===============================================================================
# useful variables
UCX_DIR = ucx-$(UCX_VER)

#===============================================================================
.PHONY: ucx
ucx: $(BUILD_DIR)/ucx.complete

#-------------------------------------------------------------------------------
ucx.complete:
	$(info >>>>>>>> UCX)
	@cd $(BUILD_DIR)
	$(info get the tar $(TAR_DIR)/$(UCX_DIR))
	@cp $(TAR_DIR)/$(UCX_DIR).tar.gz $(BUILD_DIR)
	@tar -xvf $(UCX_DIR).tar.gz
	@cd $(UCX_DIR)
	$(info configure)
	CC=$(CC) CXX=$(CXX) FC=$(FC) F77=$(FC) ./configure --prefix=${PREFIX} --enable-compiler-opt=3
	$(info install to $(PREFIX))
	make install -j
	$(info write the complete file)
	@cd $(BUILD_DIR)
	date > ucx.complete
	hostname >> ucx.complete

#-------------------------------------------------------------------------------
.PHONY: ucx_info
.NOTPARALLEL: ucx_info
ucx_info:
	$(info --------------------------------------------------------------------------------)
	$(info UCX)
	$(info - version: $(UCX_VER))
	$(info )

#-------------------------------------------------------------------------------
.PHONY: ucx_clean
ucx_clean: 
	@rm -rf ucx.complete
