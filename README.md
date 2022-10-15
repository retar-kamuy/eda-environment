verilator --Mdir obj_dir --sc --exe -Wall sc_main.cpp our.sv
verilator --Mdir obj_dir --sc --exe --build -j 0 -Wall sc_main.cpp our.sv

make -j -C obj_dir -f Vour.mk Vour

obj_dir/Vour

cd /usr/local/src
cd systemc-2.3.3
mkdir objdir
export CXX=g++
../configure --prefix=/usr/local/systemc-2.3.2
gmake 
gmake check
gmake install
cd ..
rm -rf objdir

export SYSTEMC_HOME=/usr/local/systemc-2.3.2
export SYSTEMC_INCLUDE=$SYSTEMC_HOME/include
export SYSTEMC_LIBDIR=$SYSTEMC_HOME/lib-linux64
export LD_LIBRARY_PATH=$SYSTEMC_LIBDIR:$LD_LIBRARY_PATH