#!/usr/bin/env bash

VERSION=2.3.3
export CC=clang
export CXX=clang++

sudo apt-get install -y git make automake
sudo ln -s /usr/bin/aclocal /usr/bin/aclocal-1.14
sudo ln -s /usr/bin/automake /usr/bin/automake-1.14

git clone https://github.com/accellera-official/systemc.git
cd systemc
git pull
git checkout $VERSION

autoconf

mkdir objdir
cd objdir

../configure --prefix=/opt/systemc-$VERSION
gmake -j $(nproc)
# gmake check
sudo gmake install

cd ..
rm -rf objdir
sudo unlink /usr/bin/aclocal-1.14
sudo unlink /usr/bin/automake-1.14
