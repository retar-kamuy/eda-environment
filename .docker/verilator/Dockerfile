FROM rockylinux:8
ARG VER=5.026
ENV CC=clang
ENV CXX=clang++
ENV PREFIX=/usr/local/verilator
ENV SYSTEMC_HOME=/usr/local/systemc
ENV SYSTEMC_INCLUDE=${SYSTEMC_HOME}/include
ENV SYSTEMC_LIBDIR=${SYSTEMC_HOME}/lib-linux64
RUN dnf -y install clang \
    && dnf -y install git perl python3 make autoconf flex bison \
    && dnf -y install epel-release \
    && dnf -y install ccache \
    && dnf -y --enablerepo=powertools install help2man \
    && dnf -y install gperftools-devel numactl \
    && dnf -y install zlib zlib-devel \
    && git clone https://github.com/verilator/verilator \
    && cd verilator \
    && git switch v${VER} --detach \
    && autoconf \
    && ./configure --prefix=${PREFIX} \
    && make -j`nproc` \
    && make install \
    && cd .. \
    && rm -rf verilator \
    && dnf clean all
