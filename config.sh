
CONFIG_WITH_P4EST=false
CONFIG_WITH_LIBMPIDYNRES=false

CONFIG_BUILD_OPENPMIX=false
CONFIG_BUILD_PRRTE=false
CONFIG_BUILD_OMP=false

CONFIG_OPENPMIX_CONFIGURE="--disable-werror --with-hwloc=$HWLOC_INSTALL_PATH --with-libevent=$LIBEVENT_INSTALL_PATH"
CONFIG_PRRTE_CONFIGURE="--disable-werror --with-hwloc=$HWLOC_INSTALL_PATH --with-libevent=$LIBEVENT_INSTALL_PATH"
CONFIG_OMP_CONFIGURE="--disable-werror --with-hwloc=$HWLOC_INSTALL_PATH --with-libevent=$LIBEVENT_INSTALL_PATH"

PP=( "$@" )

if [[ "${#PP[@]}" == 0 ]]; then
	echo ""
	echo "Usage: $0 [options]"
	echo ""
	echo "	'all':	build with all packages (in same order as below)"
	echo ""
	echo "	'openpmix':	build with openpmix"
	echo "	'prrte':	build with prrte"
	echo "	'omp':	build with Open-MPI"
	echo ""
	exit 1
fi

if [[ " ${PP[*]} " =~ " all " ]]; then
	CONFIG_BUILD_OPENPMIX=true
	CONFIG_BUILD_PRRTE=true
	CONFIG_BUILD_OMP=true
fi

if [[ " ${PP[*]} " =~ " openpmix " ]]; then
	CONFIG_BUILD_OPENPMIX=true
fi

if [[ " ${PP[*]} " =~ " prrte " ]]; then
	CONFIG_BUILD_PRRTE=true
fi

if [[ " ${PP[*]} " =~ " omp " ]]; then
	CONFIG_BUILD_OMP=true
fi
