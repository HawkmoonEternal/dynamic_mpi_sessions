#! /bin/bash

# Exit on errors
set -e

source env_vars.sh
source config.sh


function ERROR_MSG {
	LATEST_FILE=$(ls -Art1 $DYNMPI_BASE/output_*.txt | tail -n 1 2>/dev/null)

	if [ "$(echo "$LATEST_FILE" | wc -w)" != "0" ]; then
		echo "Showing last lines of $LATEST_FILE" 1>&2
		tail -n 20 "$LATEST_FILE" 1>&2
		echo "" 1>&2
		echo "Error, see above and also output_* files" 1>&2
	fi
	echo "Last command was:" 1>&2
	echo "$@" 1>&2

	exit 1
}

# Execute some program and its parameters, but first print out the program and parameters
function EXEC {
	echo "EXEC: $@" 1>&2

	# We also redirect stderr to stdout to catch it
	$@ 2>&1 || ERROR_MSG $@
}

if false; then
	echo "Exporting the hwloc and libevent install paths"
	export HWLOC_INSTALL_PATH=[/path/to/hwloc]
	export LIBEVENT_INSTALL_PATH=[/path/to/libevent]
	CONFIGURE_PARAMETERS=--with-hwloc=$HWLOC_INSTALL_PATH --with-libevent=$LIBEVENT_INSTALL_PATH
fi

GIT_CLONE_PARAMS="--depth=1 --branch=merge_master_time-x"

if $CONFIG_BUILD_OPENPMIX; then

	echo
	echo "***********************************************"
	echo "* Building Open-PMIx..."
	echo "***********************************************"

	EXEC cd "$DYNMPI_BASE/"

	DST_DIR=./build/openpmix
	if [ -d "$DST_DIR" ]; then
		echo "Directory '$DST_DIR' already exists, skipping git clone"
	else
		EXEC mkdir -p build
		EXEC git clone $GIT_CLONE_PARAMS https://github.com/HawkmoonEternal/openpmix ./build/openpmix
	fi

	EXEC cd "$DYNMPI_BASE/build/openpmix"

	echo " + Running autogen.pl ..."
	EXEC ./autogen.pl > $DYNMPI_BASE/output_openpmix_autogen.txt

	echo " + Running configure ..."
	EXEC ./configure --prefix=$PMIX_ROOT $CONFIG_OPENPMIX_CONFIGURE > $DYNMPI_BASE/output_openpmix_configure.txt || ERROR_MSG

	echo " + Running make ..."
	EXEC make -j > $DYNMPI_BASE/output_openpmix_make.txt || ERROR_MSG

	echo " + Running make install ..."
	EXEC make all install > $DYNMPI_BASE/output_openpmix_make_install.txt || ERROR_MSG

	echo "Installation of Open-PMIx successful"
fi

#CONFIGURE_PARAMETERS="$CONFIGURE_PARAMETERS --includedir=$DYNMPI_BASE/install/pmix/include/"
CONFIGURE_PARAMETERS="$CONFIGURE_PARAMETERS"

if $CONFIG_BUILD_PRRTE; then

	echo
	echo "***********************************************"
	echo "* Building PRRTE..."
	echo "***********************************************"

	EXEC cd "$DYNMPI_BASE/"

	DST_DIR=./build/prrte
	if [ -d "$DST_DIR" ]; then
		echo "Directory '$DST_DIR' already exists, skipping git clone"
	else
		EXEC mkdir -p build
		EXEC git clone $GIT_CLONE_PARAMS https://github.com/HawkmoonEternal/prrte ./build/prrte
	fi

	EXEC cd "$DYNMPI_BASE/build/prrte"

	echo " + Running autogen.pl ..."
	EXEC ./autogen.pl > $DYNMPI_BASE/output_prrte_autogen.txt || ERROR_MSG

	echo " + Running configure ..."
	echo ./configure --prefix=$PRRTE_ROOT $CONFIGURE_PARAMETERS -with-pmix=$PMIX_ROOT
	EXEC ./configure --prefix=$PRRTE_ROOT $CONFIGURE_PARAMETERS -with-pmix=$PMIX_ROOT $CONFIG_PRRTE_CONFIGURE > $DYNMPI_BASE/output_prrte_configure.txt || ERROR_MSG

	echo " + Running make ..."
	EXEC make -j > $DYNMPI_BASE/output_prrte_make.txt || ERROR_MSG

	echo " + Running make install ..."
	EXEC make all install > $DYNMPI_BASE/output_prrte_make_install.txt || ERROR_MSG
	echo "Installation of PRRTE successful"
fi

if $CONFIG_BUILD_OMP; then

	echo
	echo "***********************************************"
	echo "* Building Open-MPI..."
	echo "***********************************************"

	EXEC cd "$DYNMPI_BASE/"

	DST_DIR=./build/ompi
	if [ -d "$DST_DIR" ]; then
		echo "Directory '$DST_DIR' already exists, skipping git clone"
	else
		mkdir -p build
		EXEC git clone --recursive $GIT_CLONE_PARAMS https://github.com/HawkmoonEternal/ompi ./build/ompi
	fi

	EXEC cd $DYNMPI_BASE/build/ompi

	echo " + Running autogen.pl ..."
	EXEC ./autogen.pl > $DYNMPI_BASE/output_ompi_autogen.txt || ERROR_MSG

	echo " + Running configure ..."
	EXEC ./configure --prefix=$OMPI_ROOT $CONFIGURE_PARAMETERS --with-pmix=$PMIX_ROOT --with-prrte=$PRRTE_ROOT --with-ucx=no --disable-mpi-fortran $CONFIG_OMP_CONFIGURE > $DYNMPI_BASE/output_omp_configure.txt || ERROR_MSG

	echo " + Running make ..."
	EXEC make -j > $DYNMPI_BASE/output_omp_make.txt || ERROR_MSG

	echo " + Running make install ..."
        EXEC make all install > $DYNMPI_BASE/output_omp_make_install.txt || ERROR_MSG
	echo "Installation of Open-MPI successful"
fi

if $CONFIG_WITH_P4EST; then
	echo "(Optional) Building P4est (you might also need to consider the README.md in the build/p4est_dynres/p4est directory)"
	cd $DYNMPI_BASE/build/p4est_dynres/p4est
	echo "(When compiling for the first time, it might be necessary to call ./bootstrap)"
	EXEC ./configure --enable-mpi --without-blas
	EXEC make && make install
	export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$DYNMPI_BASE/build/p4est_dynres/p4est/local/lib
fi


if $CONFIG_WITH_LIBMPIDYNRES; then
	echo "(Optional) Building libmpidynres"
	EXEC cd $DYNMPI_BASE/build/p4est_dynres/libmpidynres
	EXEC make && make install
	export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$DYNMPI_BASE/build/p4est_dynres/libmpidynres/build/lib
fi
