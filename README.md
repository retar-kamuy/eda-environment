# Verilator

# SystemC setup

```bash
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
```

# Run Verilator

```bash
verilator --Mdir obj_dir --sc --exe -Wall sc_main.cpp our.sv
# or verilator --Mdir obj_dir --sc --exe --build -j 0 -Wall sc_main.cpp our.sv

make -j -C obj_dir -f Vour.mk Vour

obj_dir/Vour
```

# Setting SystemC path

```bash
export SYSTEMC_HOME=/usr/local/systemc-2.3.2
export SYSTEMC_INCLUDE=$SYSTEMC_HOME/include
export SYSTEMC_LIBDIR=$SYSTEMC_HOME/lib-linux64
export LD_LIBRARY_PATH=$SYSTEMC_LIBDIR:$LD_LIBRARY_PATH
```

# Questa SystemC run
```bash
# SystemC wrapper generate
vlog -sv top.v
scgenmod -bool -sc_uint Vour > Vour.h

# Questa SystemC compile and link
sccom -g sc_top.cpp
sccom -link

# Questa run simulation
vsim -c sc_top -do "run -all"
```