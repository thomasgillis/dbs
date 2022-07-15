# build recipe for NUMA
#-------------------------------------------------------------------------------
numa_dep = 

define numa_template_opt
	target="numa" \
	target_ver="$(NUMA_VER)" \
	target_dep="$(numa_dep)" \
	target_url="https://github.com/numactl/numactl/releases/download/v$(NUMA_VER)/numactl-$(NUMA_VER).tar.gz" \
	target_precmd="./autogen.sh"
	target_confcmd="CC=$(CC) CXX=$(CXX) FC=$(FC) F77=$(FC) ./configure --prefix=${DBS_PREFIX}" \
	target_confopt="CFLAGS=-fPIC"
endef



#===============================================================================
.PHONY: numa
numa: $(numa_dep)
ifdef NUMA_VER
	@$(numa_template_opt) $(MAKE) --file=template.mak doit
else
	@$(numa_template_opt) $(MAKE) --file=template.mak tit
endif

#-------------------------------------------------------------------------------
.PHONY: numa_tar
numa_tar: 
ifdef NUMA_VER
	@$(numa_template_opt) $(MAKE) --file=template.mak tar
else
	@$(numa_template_opt) $(MAKE) --file=template.mak ttar
endif

#-------------------------------------------------------------------------------
.PHONY: numa_info
numa_info:
ifdef NUMA_VER
	@$(numa_template_opt) $(MAKE) --file=template.mak info
else
	@$(numa_template_opt) $(MAKE) --file=template.mak info_none
endif

#-------------------------------------------------------------------------------
.PHONY: numa_clean
numa_clean: 
	@$(numa_template_opt) $(MAKE) --file=template.mak clean

#-------------------------------------------------------------------------------
.PHONY: numa_reallyclean
numa_reallyclean: 
	@$(numa_template_opt) $(MAKE) --file=template.mak reallyclean


