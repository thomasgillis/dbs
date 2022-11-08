# # build recipe for GBENCH
#-------------------------------------------------------------------------------
# dependency list
gbench_dep = 
gbench_opt = -DBENCHMARK_DOWNLOAD_DEPENDENCIES=ON -DCMAKE_INSTALL_PREFIX=${PREFIX}

define gbench_template_opt
	target="gbench" \
	target_ver="$(GBENCH_VER)" \
	target_dep="$(gbench_dep)" \
	target_url="https://github.com/google/benchmark/archive/refs/tags/v${GBENCH_VER}.tar.gz" \
	target_precmd="cmake -E make_directory "build"" \
	target_confcmd="cmake -DCMAKE_C_COMPILER=${CC} -DCMAKE_CXX_COMPILER=${CXX} -DCMAKE_BUILD_TYPE=Release -S . -B "build""\
	target_confopt="$(gbench_opt)" \
	target_installcmd="cmake --build "build" --config Release --target install"
endef

#===============================================================================
.PHONY: gbench
gbench: $(gbench_dep)
ifdef GBENCH_VER
	@$(gbench_template_opt) $(MAKE) --file=template.mak doit
else
	@$(gbench_template_opt) $(MAKE) --file=template.mak tit
endif

#-------------------------------------------------------------------------------
.PHONY: gbench_tar
gbench_tar: 
ifdef GBENCH_VER
	@$(gbench_template_opt) $(MAKE) --file=template.mak tar
else
	@$(gbench_template_opt) $(MAKE) --file=template.mak ttar
endif

#-------------------------------------------------------------------------------
.PHONY: gbench_info
gbench_info:
ifdef GBENCH_VER
	@$(gbench_template_opt) $(MAKE) --file=template.mak info
else
	@$(gbench_template_opt) $(MAKE) --file=template.mak info_none
endif

#-------------------------------------------------------------------------------
.PHONY: gbench_clean
gbench_clean: 
	@$(gbench_template_opt) $(MAKE) --file=template.mak clean

#-------------------------------------------------------------------------------
.PHONY: gbench_reallyclean
gbench_reallyclean: 
	@$(gbench_template_opt) $(MAKE) --file=template.mak reallyclean

