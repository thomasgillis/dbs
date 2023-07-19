# build recipe for GKLIB
#===============================================================================
# useful variables
GKLIB_DIR = gklib-$(GKLIB_VER)


#===============================================================================
.PHONY: gklib
gklib: $(PREFIX)/gklib.complete

#-------------------------------------------------------------------------------
gklib_tar: $(TAR_DIR)/$(GKLIB_DIR).tar.gz

$(TAR_DIR)/$(GKLIB_DIR).tar.gz: | $(TAR_DIR)
ifdef GKLIB_VER
	cd $(TAR_DIR) &&  \
	rm -rf $(GKLIB_DIR) && \
	git clone git@github.com:KarypisLab/GKlib.git gklib && \
	mv gklib $(GKLIB_DIR) && \
	cd $(GKLIB_DIR) && \
	git checkout $(GKLIB_VER) && \
	cd $(TAR_DIR)  && tar -czvf $(GKLIB_DIR).tar.gz $(GKLIB_DIR) && \
	rm -rf $(GKLIB_DIR)  
else
	touch $(TAR_DIR)/$(GKLIB_DIR).tar.gz
endif

#-------------------------------------------------------------------------------
$(PREFIX)/gklib.complete: | $(PREFIX) $(TAR_DIR)/$(GKLIB_DIR).tar.gz
ifdef GKLIB_VER
	mkdir -p $(COMP_DIR)  && \
	cd $(COMP_DIR)  && \
	cp $(TAR_DIR)/$(GKLIB_DIR).tar.gz $(COMP_DIR)  && \
	tar -xvf $(GKLIB_DIR).tar.gz  && \
	cd $(GKLIB_DIR)  && \
	make config cc=$(DBS_MPICC) prefix=$(PREFIX)  && \
	$(MAKE) install  && \
	date > $@  && \
	hostname >> $@  && \
	git describe --always --dirty >> $@
else
	touch $(PREFIX)/gklib.complete
endif

#-------------------------------------------------------------------------------
.PHONY: gklib_info
.NOTPARALLEL: gklib_info
gklib_info:
ifdef GKLIB_VER
	$(info - GKLIB branch: $(GKLIB_VER))
else
	$(info - GKLIB not built)
endif

#-------------------------------------------------------------------------------
.PHONY: gklib_reallyclean
gklib_reallyclean: 
	@rm -rf $(TAR_DIR)/$(GKLIB_DIR).tar.gz
#-------------------------------------------------------------------------------
.PHONY: gklib_clean
gklib_clean: 
	@rm -rf $(PREFIX)/gklib.complete
