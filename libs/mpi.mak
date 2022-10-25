# build recipe for MPI
# builds a very simple and dummy surrogate for mpich or openmpi
#===============================================================================
# assign DBS compiler variable
ifdef MPICH_VER
# mpich is the dep
mpi_dep = mpich
# reassign the version
MPI_VER = $(MPICH_VER)
# assign compilers
DBS_MPICC = $(PREFIX)/bin/mpicc
DBS_MPICXX = $(PREFIX)/bin/mpicxx
DBS_MPIFORT = $(PREFIX)/bin/mpif90
DBS_MPIEXEC = $(PREFIX)/bin/mpiexec
else ifdef OMPI_VER
# ompi is the dep
mpi_dep = ompi
# reassign the version
MPI_VER = $(OMPI_VER)
# assign compilers
DBS_MPICC = $(PREFIX)/bin/mpicc
DBS_MPICXX = $(PREFIX)/bin/mpicxx
DBS_MPIFORT = $(PREFIX)/bin/mpif90
DBS_MPIEXEC = $(PREFIX)/bin/mpirun
else
DBS_MPICC ?= mpicc
DBS_MPICXX ?= mpic++
DBS_MPIFORT ?= mpif90
DBS_MPIEXEC ?= mpiexec
endif

#-------------------------------------------------------------------------------
define mpi_template_opt
    target="mpi" \
    target_ver="$(MPI_VER)" \
    target_dep="$(mpi_dep)" \
    target_url="" \
    target_confcmd="" \
    target_confopt=""
endef

#===============================================================================
# by default we only touch the mpi.complete file, nothing to do there
.PHONY: mpi
mpi: $(mpi_dep)
	@$(mpi_template_opt) $(MAKE) --file=template.mak tit

#-------------------------------------------------------------------------------
.PHONY: mpi_tar
mpi_tar: | $(foreach dep,$(mpi_dep),$(dep)_tar) 

#-------------------------------------------------------------------------------
.PHONY: mpi_info
mpi_info: $(foreach dep,$(mpi_dep),$(dep)_info) 

#	@echo "DBS CC: $(DBS_MPICC)"
#	@echo "DBS CXX: $(DBS_MPICXX)"

#-------------------------------------------------------------------------------
.PHONY: mpi_clean
mpi_clean:  $(foreach dep,$(mpi_dep),$(dep)_tar) 

#-------------------------------------------------------------------------------
.PHONY: mpi_reallyclean
mpi_reallyclean:  $(foreach dep,$(mpi_dep),$(dep)_tar) 


