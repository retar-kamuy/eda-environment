FROM rockylinux:8 AS systemc
ARG SYSTEMC_VER=2.3.4
ARG CCI_VER=1.0.1
ENV CC=clang
ENV CXX=clang++
ENV SYSTEMC_PREFIX=/usr/local/systemc
ENV CCI_PREFIX=/usr/local/cci
ENV SYSTEMC_HOME=${SYSTEMC_PREFIX}
ENV SYSTEMC_INC_DIR=${SYSTEMC_HOME}/include
ENV SYSTEMC_LIB_DIR=${SYSTEMC_HOME}/lib-linux64
ENV LD_LIBRARY_PATH=${SYSTEMC_LIB_DIR}
RUN dnf -y install clang git make automake autoconf \
    && dnf -y --enablerepo=devel install libtool \
    && git clone https://github.com/accellera-official/systemc.git \
    && cd systemc \
    && git switch ${SYSTEMC_VER} --detach \
    && ./config/bootstrap \
    && mkdir objdir \
    && cd objdir \
    && ../configure --prefix=${SYSTEMC_PREFIX} --enable-pthreads \
    && make -j`nproc` \
    && make check \
    && make install \
    && cd ../.. \
    && rm -rf systemc \
    && dnf -y install rapidjson-devel \
    && git clone https://github.com/accellera-official/cci.git \
    && cd cci \
    && git switch v$CCI_VER --detach \
    && ./config/bootstrap \
    && mkdir objdir \
    && cd objdir \
    && ../configure \
        --prefix=${CCI_PREFIX} \
        --with-systemc=${SYSTEMC_PREFIX} \
        --with-json=/usr \
        --includedir=${CCI_INC_DIR}/include \
        --libdir=${CCI_PREFIX}/lib-linux64 \
    && make -j`nproc` \
    && make check \
    && make install \
    && cd ../.. \
    && rm -rf cci \
    && dnf clean all
