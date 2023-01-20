# Towards Dynamic Resource Management with MPI Sessions and PMIx - Prototype Code for Benchmarks
## Introduction
This repository provides the code of the prototype developed in the context of my master's thesis "Towards Dynamic Resource Management with MPI Sessions and PMIx". 

The goal of this project is to develop resource adaptive MPI applications and runtime environments by extending the MPI Sessions model and PMIx. This prototype implementation is based on the Open-MPI code, i.e. the sessions_pr branch invloved in the following pull request: https://github.com/opne-mpi/ompi/pull/9097  


The prototype version provided in this repository was used for the performance evaluation on the LRZ Linux Cluster presented in my thesis. This prototype is currently under further development in the following repository: https://github.com/HawkmoonEternal/dynmpi_prototype_dev.git

## Prerequisits
Open-MPI:
* m4 1.4.17
* autoconf 2.69
* automake 1.15
* libtool 2.4.6
* flex 2.5.35
* hwloc 2.5
* libevent 2.1.12
* zlib (recommended)

Building the benchmarks:
* scons 

## Compiling and Installing

There's a special compile script automizing many steps:

```
./install.sh all
'''


(Optional) Building P4est (you might also need to consider the README.md in the build/p4est_dynres/p4est directory):

`cd $DYNMPI_BASE/build/p4est_dynres/p4est`

(When compiling for the first time, it might be necessary to call `./bootstrap`)

`./configure --enable-mpi --without-blas`

`make && make install`

`export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$DYNMPI_BASE/build/p4est_dynres/p4est/local/lib`

(Optional) Building libmpidynres (you might also need to consider the README.md in the build/p4est_dynres/libmpidynres directory):

`cd $DYNMPI_BASE/build/p4est_dynres/libmpidynres`

`make && make install`

`export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$DYNMPI_BASE/build/p4est_dynres/libmpidynres/build/lib`

Building the benchmarks:

`scons example=DynMPISessions_[v1/v1_nb/v2a/v2a_nb/v2b/v2b_nb] compileMode=[debug/release]`

## Running the benchmarks
Note: The `DYNMPI_BASE environment variable has to be added to the environment on every invloved node. Using the -x option for the prterun command is mandatory but eventually not sufficient.

### Synthetic Benchmark:
* Incremental mode (Addition)

`prterun -np 28 --mca btl_tcp_if_include eth0 -H node01:28,node02:28,node03:28,node04:28 -x LD_LIBRARY_PATH -x DYNMPI_BASE $DYNMPI_BASE/build/p4est_dynres/applications/build/SWE_p4est_benchOmpidynresSynthetic_release -c 70 -l 122 -m i+ -n 28 -f 10 -b 0`

`prterun -np 28 --mca btl_tcp_if_include eth0 -H node01:28,node02:28,node03:28,node04:28 -x LD_LIBRARY_PATH -x DYNMPI_BASE $DYNMPI_BASE/build/p4est_dynres/applications/build/SWE_p4est_benchOmpidynresSynthetic_release -c 70 -l 122 -m i+ -n 28 -f 10 -b 1`

* Incremental mode (Subtraction)

`prterun -np 122 --mca btl_tcp_if_include eth0 -H node01:28,node02:28,node03:28,node04:28 -x LD_LIBRARY_PATH -x DYNMPI_BASE $DYNMPI_BASE/build/p4est_dynres/applications/build/SWE_p4est_benchOmpidynresSynthetic_release -c 70 -l 28 -m i_ -n 28 -f 10 -b 0`

`prterun -np 122 --mca btl_tcp_if_include eth0 -H node01:28,node02:28,node03:28,node04:28 -x LD_LIBRARY_PATH -x DYNMPI_BASE $DYNMPI_BASE/build/p4est_dynres/applications/build/SWE_p4est_benchOmpidynresSynthetic_release -c 70 -l 28 -m i_ -n 28 -f 10 -b 1`


* Step mode:

`prterun -np 28 --mca btl_tcp_if_include eth0 -H node01:28,node02:28,node03:28,node04:28 -x LD_LIBRARY_PATH -x DYNMPI_BASE $DYNMPI_BASE/build/p4est_dynres/applications/build/SWE_p4est_benchOmpidynresSynthetic_release -c 70 -l 122 -m s+ -n 28 -f 10 -b 0`

`prterun -np 28 --mca btl_tcp_if_include eth0 -H node01:28,node02:28,node03:28,node04:28 -x LD_LIBRARY_PATH -x DYNMPI_BASE $DYNMPI_BASE/build/p4est_dynres/applications/build/SWE_p4est_benchOmpidynresSynthetic_release -c 70 -l 122 -m s+ -n 28 -f 10 -b 1`

### SWE Benchmark:

`prterun -np 28 --mca btl_tcp_if_include eth0 -H node01:28,node02:28,node03:28,node04:28 -x LD_LIBRARY_PATH -x DYNMPI_BASE $DYNMPI_BASE/build/p4est_dynres/applications/build/SWE_p4est_benchOmpidynresFixed_release -c 10 -t 10 -l 122 -m i+ -n 28 -f 10 -b 1`

`prterun -np 28 --mca btl_tcp_if_include eth0 -H node01:28,node02:28,node03:28,node04:28 -x LD_LIBRARY_PATH -x DYNMPI_BASE $DYNMPI_BASE/build/p4est_dynres/applications/build/SWE_p4est_benchOmpidynresFixed_release -c 10 -t 10 -l 122 -m i+ -n 28 -f 1 -b 0`

## Contact
In case of any questions please contact me via email: `domi.huber@tum.de`


