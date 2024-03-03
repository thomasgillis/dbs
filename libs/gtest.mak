# # build recipe for GTEST
#-------------------------------------------------------------------------------
# dependency list
gtest_dep = 
gtest_opt = -DCMAKE_INSTALL_PREFIX=${PREFIX}

define gtest_template_opt
	target="gtest" \
	target_ver="$(GTEST_VER)" \
	target_dep="$(gtest_dep)" \
	target_url="https://github.com/google/googletest/archive/refs/tags/v${GTEST_VER}.tar.gz" \
	target_confcmd="cmake . -DCMAKE_C_COMPILER=${CC} -DCMAKE_CXX_COMPILER=${CXX} -DCMAKE_INSTALL_LIBDIR=${PREFIX}/lib"\
	target_confopt="$(gtest_opt)" \
	target_installcmd="make install -j"
endef

#===============================================================================
.PHONY: gtest
gtest: $(gtest_dep)
ifdef GTEST_VER
	@$(gtest_template_opt) $(MAKE) --file=template.mak doit
else
	@$(gtest_template_opt) $(MAKE) --file=template.mak tit
endif

#-------------------------------------------------------------------------------
.PHONY: gtest_tar
gtest_tar: 
ifdef GTEST_VER
	@$(gtest_template_opt) $(MAKE) --file=template.mak tar
else
	@$(gtest_template_opt) $(MAKE) --file=template.mak ttar
endif

#-------------------------------------------------------------------------------
.PHONY: gtest_info
gtest_info:
ifdef GTEST_VER
	@$(gtest_template_opt) $(MAKE) --file=template.mak info
else
	@$(gtest_template_opt) $(MAKE) --file=template.mak info_none
endif

#-------------------------------------------------------------------------------
.PHONY: gtest_clean
gtest_clean: 
	@$(gtest_template_opt) $(MAKE) --file=template.mak clean

#-------------------------------------------------------------------------------
.PHONY: gtest_reallyclean
gtest_reallyclean: 
	@$(gtest_template_opt) $(MAKE) --file=template.mak reallyclean

