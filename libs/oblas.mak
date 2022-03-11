# # build recipe for OBLAS
#-------------------------------------------------------------------------------
define oblas_template_opt
	target="oblas" \
	target_ver="$(OBLAS_VER)"" \
	target_url="https://github.com/xianyi/OpenBLAS/archive/v$(OBLAS_VER).tar.gz" \
	target_confcmd="$(MAKE) USE_OPENMP=1 PREFIX=${PREFIX} -j8" \
	target_installcmd="$(MAKE) PREFIX=${PREFIX} install -j8"
endef

#===============================================================================
.PHONY: oblas
oblas:
ifdef OBLAS_VER
	@$(oblas_template_opt) $(MAKE) --file=template.mak doit
else
	@$(oblas_template_opt) $(MAKE) --file=template.mak tit
endif

#===============================================================================
.PHONY: oblas
oblas:
ifdef OBLAS_VER
	@$(oblas_template_opt) $(MAKE) --file=template.mak tar
else
	@$(oblas_template_opt) $(MAKE) --file=template.mak ttar
endif

#-------------------------------------------------------------------------------
.PHONY: oblas_info
oblas_info:
ifdef OBLAS_VER
	@$(oblas_template_opt) $(MAKE) --file=template.mak template_info
else
	@$(oblas_template_opt) $(MAKE) --file=template.mak template_info_none
endif

#-------------------------------------------------------------------------------
.PHONY: oblas_clean
oblas_clean: 
	@$(oblas_template_opt) $(MAKE) --file=template.mak tempalte_clean

#-------------------------------------------------------------------------------
.PHONY: oblas_reallyclean
oblas_reallyclean: 
	@$(oblas_template_opt) $(MAKE) --file=template.mak template_reallyclean


# build recipe for OBLAS
# #===============================================================================
# # useful variables
# OBLAS_DIR = OpenBLAS-$(OBLAS_VER)

# #===============================================================================
# .PHONY: oblas
# .NOTPARALLEL: oblas
# oblas: $(PREFIX)/oblas.complete

# #-------------------------------------------------------------------------------
# .PHONY: oblas_tar
# oblas_tar: $(TAR_DIR)/oblas-$(OBLAS_VER).tar.gz 

# $(TAR_DIR)/oblas-$(OBLAS_VER).tar.gz: | $(TAR_DIR)
# ifdef OBLAS_VER
# 	cd $(TAR_DIR) && \
# 	wget 'https://github.com/xianyi/OpenBLAS/archive/v$(OBLAS_VER).tar.gz' &&\
# 	mv v$(OBLAS_VER).tar.gz oblas-$(OBLAS_VER).tar.gz
# else
# 	touch $(TAR_DIR)/oblas-$(OBLAS_VER).tar.gz
# endif

# #-------------------------------------------------------------------------------
# $(PREFIX)/oblas.complete: | $(PREFIX) $(TAR_DIR)/oblas-$(OBLAS_VER).tar.gz
# ifdef OBLAS_VER
# 	mkdir -p $(COMP_DIR)  && \
# 	cd $(COMP_DIR) &&\
# 	cp $(TAR_DIR)/oblas-$(OBLAS_VER).tar.gz $(COMP_DIR) &&\
# 	tar -xvf oblas-$(OBLAS_VER).tar.gz &&\
# 	cd $(OBLAS_DIR) &&\
# 	$(MAKE) USE_OPENMP=1 PREFIX=${PREFIX} -j 8 &&\
# 	$(MAKE) PREFIX=${PREFIX} install -j 8 &&\
# 	date > $@ &&\
# 	hostname >> $@
# else
# 	touch $(PREFIX)/oblas.complete
# endif

# #-------------------------------------------------------------------------------
# .PHONY: oblas_info
# .NOTPARALLEL: oblas_info
# oblas_info:
# ifdef OBLAS_VER
# 	$(info - OpenBlas version: $(OBLAS_VER))
# else
# 	$(info - OpenBlas not built)
# endif

# #-------------------------------------------------------------------------------
# .PHONY: oblas_reallyclean
# oblas_reallyclean: 
# 	@rm -rf $(TAR_DIR)/oblas-$(OBLAS_VER).tar.gz
# #-------------------------------------------------------------------------------
# .PHONY: oblas_clean
# oblas_clean: 
# 	@rm -rf $(PREFIX)/oblas.complete
