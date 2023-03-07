# # build recipe for osu
#-------------------------------------------------------------------------------
# dependency list
osu_dep = mpi

osu_opt = ${OSU_MISC_OPTS}

define osu_template_opt
	target="osu" \
	target_ver="$(OSU_VER)" \
	target_dep="$(osu_dep)" \
	target_url="https://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-$(OSU_VER).tar.gz" \
	target_confcmd="CC=$(DBS_MPICC) CXX=$(DBS_MPICXX) ./configure --prefix=${PREFIX}" \
	target_confopt="$(osu_opt)" \
	target_installcmd="$(MAKE) -j8 && make install"
endef

#===============================================================================
.PHONY: osu
osu: $(osu_dep)
ifdef OSU_VER
	@$(osu_template_opt) $(MAKE) --file=template.mak doit
else
	@$(osu_template_opt) $(MAKE) --file=template.mak tit
endif

#-------------------------------------------------------------------------------
.PHONY: osu_tar
osu_tar: 
ifdef OSU_VER
	@$(osu_template_opt) $(MAKE) --file=template.mak tar
else
	@$(osu_template_opt) $(MAKE) --file=template.mak ttar
endif

#-------------------------------------------------------------------------------
.PHONY: osu_info
osu_info:
ifdef OSU_VER
	@$(osu_template_opt) $(MAKE) --file=template.mak info
else
	@$(osu_template_opt) $(MAKE) --file=template.mak info_none
endif

#-------------------------------------------------------------------------------
.PHONY: osu_clean
osu_clean: 
	@$(osu_template_opt) $(MAKE) --file=template.mak clean

#-------------------------------------------------------------------------------
.PHONY: osu_reallyclean
osu_reallyclean: 
	@$(osu_template_opt) $(MAKE) --file=template.mak reallyclean

#-------------------------------------------------------------------------------
.PHONY: osu_dbg
osu_dbg: osu
ifdef OSU_VER
	${PREFIX}/bin/mpiexec -n ${OSU_NP} --ppn ${OSU_PPN} --gpus-per-proc 1 hostname
endif

.PHONY: osu_lat
osu_lat: osu
ifdef OSU_VER
	@echo "${OSU_RUN_OPTS} ${PREFIX}/bin/mpiexec -n ${OSU_NP} --ppn ${OSU_PPN} --gpus-per-proc 1 ${PREFIX}/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency H H";\
	${OSU_RUN_OPTS} ${PREFIX}/bin/mpiexec -n ${OSU_NP} --ppn ${OSU_PPN} --gpus-per-proc 1 ${PREFIX}/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency H H; \
	echo "${OSU_RUN_OPTS} ${PREFIX}/bin/mpiexec -n ${OSU_NP} --ppn ${OSU_PPN} --gpus-per-proc 1 ${PREFIX}/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency H D";\
	${OSU_RUN_OPTS} ${PREFIX}/bin/mpiexec -n ${OSU_NP} --ppn ${OSU_PPN} --gpus-per-proc 1 ${PREFIX}/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency H D; \
	echo "${OSU_RUN_OPTS} ${PREFIX}/bin/mpiexec -n ${OSU_NP} --ppn ${OSU_PPN} --gpus-per-proc 1 ${PREFIX}/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency D D";\
	${OSU_RUN_OPTS} ${PREFIX}/bin/mpiexec -n ${OSU_NP} --ppn ${OSU_PPN} --gpus-per-proc 1 ${PREFIX}/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency D D; 
endif

.PHONY: osu_bw
osu_bw: osu
ifdef OSU_VER
	@echo "${OSU_RUN_OPTS} ${PREFIX}/bin/mpiexec -n ${OSU_NP} --ppn ${OSU_PPN} --gpus-per-proc 1 ${PREFIX}/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_bw H H";\
	${OSU_RUN_OPTS} ${PREFIX}/bin/mpiexec -n ${OSU_NP} --ppn ${OSU_PPN} --gpus-per-proc 1 ${PREFIX}/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_bw H H; \
	echo "${OSU_RUN_OPTS} ${PREFIX}/bin/mpiexec -n ${OSU_NP} --ppn ${OSU_PPN} --gpus-per-proc 1 ${PREFIX}/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_bw H D";\
	${OSU_RUN_OPTS} ${PREFIX}/bin/mpiexec -n ${OSU_NP} --ppn ${OSU_PPN} --gpus-per-proc 1 ${PREFIX}/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_bw H D; \
	echo "${OSU_RUN_OPTS} ${PREFIX}/bin/mpiexec -n ${OSU_NP} --ppn ${OSU_PPN} --gpus-per-proc 1 ${PREFIX}/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_bw D D";\
	${OSU_RUN_OPTS} ${PREFIX}/bin/mpiexec -n ${OSU_NP} --ppn ${OSU_PPN} --gpus-per-proc 1 ${PREFIX}/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_bw D D; 
endif

#-------------------------------------------------------------------------------
