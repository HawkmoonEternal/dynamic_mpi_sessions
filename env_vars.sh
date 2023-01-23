

echo "Exporting the path to the base directory"
#export DYNMPI_BASE="$(pwd)"
export DYNMPI_BASE=/opt/hpc

export HWLOC_INSTALL_PATH=/opt/hpc/local/hwloc
export LIBEVENT_INSTALL_PATH=/opt/hpc/local/libevent


echo "Exporting the ompi, open-pmix and prrte install paths"
export PMIX_ROOT=$DYNMPI_BASE/install/pmix
export PRRTE_ROOT=$DYNMPI_BASE/install/prrte
export OMPI_ROOT=$DYNMPI_BASE/install/ompi

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PMIX_ROOT/lib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PRRTE_ROOT/lib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$OMPI_ROOT/lib


echo "Updating PATH"
export PATH="$PATH:$OMPI_ROOT/bin"
export PATH="$PATH:$PRRTE_ROOT/bin"

echo "Environment variables set up successfully"

