# build recipe for ZLIB
#===============================================================================
# useful variables
ZLIB_DIR = zlib-$(ZLIB_VER)

#===============================================================================
.PHONY: zlib
zlib: $(PREFIX)/zlib.complete

.PHONY: zlib_tar
zlib_tar: $(TAR_DIR)/$(ZLIB_DIR).tar.gz 

$(TAR_DIR)/$(ZLIB_DIR).tar.gz: | $(TAR_DIR)
ifdef ZLIB_VER
	cd $(TAR_DIR)&& \
	wget 'https://zlib.net/zlib-$(ZLIB_VER).tar.gz'
else
	touch $(TAR_DIR)/$(ZLIB_DIR).tar.gz
endif

#-------------------------------------------------------------------------------
$(PREFIX)/zlib.complete: | $(PREFIX) $(TAR_DIR)/$(ZLIB_DIR).tar.gz
ifdef ZLIB_VER
	mkdir -p $(COMP_DIR)  && \
	cd $(COMP_DIR)  && \
	cp $(TAR_DIR)/$(ZLIB_DIR).tar.gz $(COMP_DIR)  && \
	tar -xvf $(ZLIB_DIR).tar.gz  && \
	cd $(ZLIB_DIR)  && \
	CC=$(CC) CXX=$(CXX) FC=$(FC) F77=$(FC) ./configure --prefix=${PREFIX} && \
	$(MAKE) install -j 8 && \
	date > $@  && \
	hostname >> $@
else
	touch $(PREFIX)/zlib.complete
endif

#-------------------------------------------------------------------------------
.PHONY: zlib_info
.NOTPARALLEL: zlib_info
zlib_info:
ifdef ZLIB_VER
	$(info - ZLIB version: $(ZLIB_VER))
else
	$(info - ZLIB not built)
endif

#-------------------------------------------------------------------------------
.PHONY: zlib_clean
zlib_clean: 
	@rm -rf $(PREFIX)/zlib.complete

#-------------------------------------------------------------------------------
.PHONY: zlib_reallyclean
zlib_reallyclean: 
	@rm -rf $(TAR_DIR)/$(ZLIB_DIR).tar.gz

