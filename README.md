# DBS - Dependency Build System

Portable and lightweight build system for your dependencies


## Global picture

We rely on the widespread `make` tool to handle the different dependencies.  Each lib's recipe is defined in the `lib.mak` file.  
For each cluster/configuration, you have to create an `.arch` file.
If you need to specify the version you want. Failing to specify a version implies that the lib will not be built

You should **always** submit a job to build the libraries as the compute nodes are usually different from the login nodes.
To help you doing that, you can use the `make submit` command.


## Usage

### Make commands

Follow the different steps here


```bash
# get the list of modules to load
CLUSTER=cluster make module

# get the general information about what is going to happen
CLUSTER=cluster make info

# get the needed tar
CLUSTER=cluster make tar

# submit the job and install everything
CLUSTER=cluster make submit
# or just install everything
CLUSTER=cluster make install
```

Once done, you can simply instruct your system to use the newly compiles libs using

```bash
# put that in your bashrc
export PREFIX=/the/prefix/you/have/used
export PATH=${PREFIX}/bin:${PATH}
```

Other make targets:

- `make info` will display general information
- `make module` will display the list of modules to load
- `make submit` will submit the job on the cluster
- `make install` will start the installation of the libs
- `make tar` will download the tar needed
- `make clean` will rm the already build `.complete` files in the `$(PREFIX)` folder
- `make reallyclean` will rm the tar in the `$(TAR_DIR)` folder


### Cluster-dependent configuration
To accomodate different clusters/use cases the user can define the following variables

- `CONF_DIR` points to the configuration directory, `config` by default
- `CLUSTERS_DIR` points to the architecture directory, `${CONF_DIR}` by default
- `SUBMIT_DIR` points to the `.sh` submission directory, `${CONF_DIR}` by default
- `SUBMIT_CMD` allows you to redefine the job-submission command, `sbatch` by default. This variable can also be set in the `.arch` file.

### Add your architecture

Each `cluster` has a corresponding `make_arch/cluster.arch` file.
In this file you should to specify

**general parameters**:

- `FC`, `CC`, and `CXX` as the non-mpi compilers to use
- `BUILD_DIR` the location where the temporary (and unique) build directory will be created
- `TAR_DIR` where the find the tar, obtained using `tar-list.sh`
- `PREFIX` where the libs will be installed

**module information**:

To centralize the module information, use the definition of the variable `MODULE_LIST`:

```makefile
define MODULE_LIST
module-name-1 \
module-name-2
endef
```

Nothing will be done with that information expect displaying it to the user if requested by `make module`


## Library dependent informations

**Library dependent parameters**

For each library you must specify the 
- `ZLIB_VER` - zlib
- `LIBEVENT_VER` - libevent
- `HWLOC_VER` - hwloc
- `PMIX_VER` - pmix
- `UCX_VER` - ucx
- `OFI_VER` - ofi/libfabric
- `OMPI_VER` - openmpi
- `HDF5_VER` - hdf5
- `FFTW_VER` - fftw
- `OBLAS_VER` - openblas
- `P4EST_VER` - p4est
- `FLUPS_VER` - flups

### OpenMPI

**OpenMPI specificities**

OpenMPI relies on other libs to handle the actual implementation over the network (`ofi` and/or `ucx`), and other part of the implementation (`pmix` etc)
If you choose to use another version of those libs (i.e. not installed through this makefile) you must declare variables to indicate where to find the lib

- `OMPI_UCX_DEP` will be `--with-ucx=no` unless you specify it otherwise
- `OMPI_OFI_DEP` will be `--with-ofi=no` unless you specify it otherwise
- `OMPI_PMIX_DEP` will be `--with-pmix=internal` unless you specify it otherwise
- `OMPI_HWLOC_DEP` will be `--with-hwloc=internal` unless you specify it otherwise
- `OMPI_ZLIB_DEP` will be `--with-zlib=internal` unless you specify it otherwise
- `OMPI_LIBEVENT_DEP` will be `--with-libevent=internal` unless you specify it otherwise
- `OMPI_MISC_OPTS` can be used to give options to `ompi`

### PMIX
**PMIX specificities**

Similar to OpenMPI, it's possible to choose where to take the different other libs from 

- `OMPI_HWLOC_DEP` will be empty unless you specify it otherwise
- `OMPI_ZLIB_DEP` will be empty unless you specify it otherwise
- `OMPI_LIBEVENT_DEP` will be empty unless you specify it otherwise


**Flups specificities**

Flups being developed, it has been decided to use a specific git branch for defining the specific version. It is therefore required to detail the needed git branch. Here is the currently used private [git repo](https://git.immc.ucl.ac.be/examples/flups) . Do not hesitate to contact the [Flups developper](mailto:thomas.gillis@uclouvain.be) to ask for an access. 


## Implementation notes

- `.NOTPARALLEL` in a makefile will force the non-parallelization of the current `make` call on all the prerequisites + recipes.
- `.PHONY` if a target is declared as `.PHONY` it will be executed only when explicitly requested by a `make` command or as a dependency.
- the dependencies for a lib must be defined on the top level and forwarded to the `template` level. The top level will ensure that the associated `lib.complete` is done before entering the compilation itself. The `template` level will make sure that the lib is recompiled in the dependency has changed
- the smaller case variables are internal to the `makefile` while the upper case variables are external (e.g. user-provided)


