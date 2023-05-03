#!/usr/bin/env bash

sudo bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)"
cd /usr/bin

sudo ln -s clang-15 clang
sudo ln -s clang++-15 clang++
