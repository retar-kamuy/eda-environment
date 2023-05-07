#!/usr/bin/env bash

VERSION=1.13.0
export CC=clang
export CXX=clang++

git clone https://github.com/google/googletest.git
cd googletest
git pull
git checkout v$VERSION

cmake -Bbuild -DCMAKE_INSTALL_PREFIX=/opt/googletest-$VERSION
cmake --build build
cmake --install build --prefix /opt/googletest-$VERSION
