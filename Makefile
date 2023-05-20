SRC			 = src/axilm.sv src/axilm_wr_ch.sv src/axilm_rd_ch.sv
TB			 = tb/tb_top.sv tb/clk_rst_gen.sv
SC_TB		 = sc_main.cpp test_axil.cpp
INCDIR		 = +incdir+tb

BUILD_DIR	 = build
WLF			 = vsim.wlf
TOP			 = $(BUILD_DIR).tb_top
DUT			 = axilm

VLOG_FLAGS	 = -l vlog.log
VSIM_FLAGS	 = -l vsim.log
VSIM_FLAGS	+= -wlf $(WLF) -do "add wave -r /*; run -all; quit"

VERILATOR_FLAGS	 = --sc --exe
VERILATOR_FLAGS	+= -Wno-lint -Wall
VERILATOR_FLAGS	+= --trace
VERILATOR_FLAGS	+= --top-module $(DUT)
VERILATOR_FLAGS	+= --Mdir $(BUILD_DIR)

SYSTEMC_HOME	 = /opt/systemc-2.3.3
SYSTEMC_INCLUDE	 = $(SYSTEMC_HOME)/include
SYSTEMC_LIBDIR	 = $(SYSTEMC_HOME)/lib-linux64

# build_questa: $(SRC) $(TB)
#	vlib $@
#	vmap $@ $@
#	vlog -work $@ $(INCDIR) $(VLOG_FLAGS) $^

# test_questa: build_questa
#	vsim -c -work $< $(VSIM_FLAGS) $(TOP)

V$(DUT).h: $(SRC)
	vlog -l vlog.log -sv $^
	scgenmod -bool -sc_uint V$(DUT) > $@

test_questa:
	sccom -g -L/opt/googletest-1.13.0/lib -lgtest -lpthread -I/opt/googletest-1.13.0/include sc_main.cpp test_axil.cpp
#	sccom -link
#	vopt +acc sc_main -o optdesign
	vsim -c -wlf vsim.wlf -l vsim.log -do "add wave -r *; run -all; quit" work.sc_top

# V$(DUT): $(SRC) $(SC_TB)
#	verilator $(VERILATOR_FLAGS) -I$(SYSTEMC_INCLUDE) $(SRC) $(SC_TB) -LDFLAGS "-L/opt/googletest-1.13.0/lib -lgtest -lpthread" -CFLAGS "-I/opt/googletest-1.13.0/include"
#	$(MAKE) -j -C $(BUILD_DIR) -f $@.mk $@
#	cp $(BUILD_DIR)/$@ .

# test_verilator: V$(DUT)
#	./$<

# test_verilator_vcd: V$(DUT)
#	./$< +trace

cmake_verilator:
	mkdir $(BUILD_DIR)
	cd $(BUILD_DIR)
	cmake -GNinja ..
	ninja
	./Vaxilm

clean:
#	del /q work *.log *.wlf
	rm -rf work *.log *.wlf *.vcd V$(DUT)
