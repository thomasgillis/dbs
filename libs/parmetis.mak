# build recipe for PARMETIS
#===============================================================================
# dependency list
parmetis_dep = gklib metis

# useful variables
PARMETIS_DIR = parmetis-$(PARMETIS_VER)


#===============================================================================
.PHONY: parmetis
parmetis: $(parmetis_dep) $(PREFIX)/parmetis.complete

#-------------------------------------------------------------------------------
parmetis_tar: $(TAR_DIR)/$(PARMETIS_DIR).tar.gz

$(TAR_DIR)/$(PARMETIS_DIR).tar.gz: | $(TAR_DIR)
ifdef PARMETIS_VER
	cd $(TAR_DIR)  &&  \
	rm -rf $(PARMETIS_DIR)  && \
	git clone https://github.com/KarypisLab/ParMETIS.git parmetis  && \
	mv parmetis $(PARMETIS_DIR)  && \
	cd $(PARMETIS_DIR)  && \
	git checkout $(PARMETIS_VER)  && \
	cd $(TAR_DIR)  && tar -czvf $(PARMETIS_DIR).tar.gz $(PARMETIS_DIR)  && \
	rm -rf $(PARMETIS_DIR)
else
	touch $(TAR_DIR)/$(PARMETIS_DIR).tar.gz
endif

#-------------------------------------------------------------------------------
$(PREFIX)/parmetis.complete:$(foreach lib,$(parmetis_dep),$(PREFIX)/$(lib).complete) | $(PREFIX) $(TAR_DIR)/$(PARMETIS_DIR).tar.gz
ifdef PARMETIS_VER
	mkdir -p $(COMP_DIR)  && \
	cd $(COMP_DIR)  && \
	cp $(TAR_DIR)/$(PARMETIS_DIR).tar.gz $(COMP_DIR)  && \
	tar -xvf $(PARMETIS_DIR).tar.gz  && \
	cd $(PARMETIS_DIR) && \
	make config cc=$(DBS_MPICC) prefix=$(PREFIX) && \
	$(MAKE) install && \
	date > $@  && \
	hostname >> $@ && \
	git describe --always --dirty >> $@
else
	touch $(PREFIX)/parmetis.complete
endif

#-------------------------------------------------------------------------------
.PHONY: parmetis_info
.NOTPARALLEL: parmetis_info
parmetis_info:
ifdef PARMETIS_VER
	$(info - PARMETIS branch: $(PARMETIS_VER))
else
	$(info - PARMETIS not built)
endif

#-------------------------------------------------------------------------------
.PHONY: parmetis_reallyclean
parmetis_reallyclean:
	@rm -rf $(TAR_DIR)/$(PARMETIS_DIR).tar.gz
#-------------------------------------------------------------------------------
.PHONY: parmetis_clean
parmetis_clean:
	@rm -rf $(PREFIX)/parmetis.complete
