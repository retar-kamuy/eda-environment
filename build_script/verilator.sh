#!/usr/bin/env bash

VERSION=5.012
export CC=clang
export CXX=clang++
SYSTEMC_HOME=/opt/systemc-2.3.3
SYSTEMC_INCLUDE=$SYSTEMC_HOME/include

sudo apt-get install -y git perl python3 make autoconf clang flex bison ccache help2man
sudo apt-get install -y libgoogle-perftools-dev numactl perl-doc
sudo apt-get install -y libfl2
sudo apt-get install -y libfl-dev
sudo apt-get install -y zlibc zlib1g zlib1g-dev
sudo apt-get install -y cmake

git clone https://github.com/verilator/verilator
cd verilator
git pull
git checkout v$VERSION

mkdir build
cmake -G Ninja .. \
    -DCMAKE_BUILD_TYPE=Release \
    --install-prefix /opt/verilator-$VERSION \
    -DCMAKE_MAKE_PROGRAM=/opt/ninja-1.11.1/bin/ninja \
    -DBISON_EXECUTABLE=/usr/bin/bison \
    -DFLEX_EXECUTABLE=/usr/bin/flex
/opt/ninja-1.11.1/bin/ninja
cmake --install . --prefix /opt/verilator-$VERSION
