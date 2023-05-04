SRC			 = src/axilm_rd_ch.sv
TB			 = tb/tb_top.sv tb/clk_rst_gen.sv
SC_TB		 = sc_main.cpp test_axi4_lite.cpp
INCDIR		 = +incdir+tb

BUILD_DIR	 = work
WLF			 = vsim.wlf
TOP			 = $(BUILD_DIR).tb_top
DUT			 = axilm_rd_ch

VLOG_FLAGS	 = -work $(BUILD_DIR) -l vlog.log
VSIM_FLAGS	 = -work $(BUILD_DIR) -l vsim.log
VSIM_FLAGS	+= -wlf $(WLF) -do "add wave -r /*; run -all; quit"

VERILATOR_FLAGS	 = --sc --exe
VERILATOR_FLAGS	+= -Wno-lint -Wall
VERILATOR_FLAGS	+= --trace
VERILATOR_FLAGS	+= --top-module $(DUT)
VERILATOR_FLAGS	+= --Mdir $(BUILD_DIR)

SYSTEMC_HOME	 = /opt/systemc-2.3.3
SYSTEMC_INCLUDE	 = $(SYSTEMC_HOME)/include
SYSTEMC_LIBDIR	 = $(SYSTEMC_HOME)/lib-linux64

$(BUILD_DIR):
	vlib $(BUILD_DIR)
	vmap $(BUILD_DIR) $(BUILD_DIR)

build: $(SRC) $(TB)
	vlog $(INCDIR) $(VLOG_FLAGS) $^

run: build
	vsim -c $(VSIM_FLAGS) $(TOP)

testbench_verilator: $(SRC) $(SC_TB)
	verilator $(VERILATOR_FLAGS) -I$(SYSTEMC_INCLUDE) $(SRC) $(SC_TB)
	$(MAKE) -j -C $(BUILD_DIR) -f V$(DUT).mk V$(DUT)
	cp $(BUILD_DIR)/V$(DUT) $@

test_verilator: testbench_verilator
	./$<

test_verilator_vcd: testbench_verilator
	./$< +trace

test_questa:
	vlib $(BUILD_DIR)
	vmap $(BUILD_DIR) $(BUILD_DIR)
	vlog -work $(BUILD_DIR) -l vlog.log -sv src/axilm_rd_ch.sv
	scgenmod -bool -sc_uint Vaxilm_rd_ch > Vaxilm_rd_ch.h
	sccom -g test_axil.cpp
	sccom -link

clean:
#	del /q work *.log *.wlf
	rm -rf work *.log *.wlf *.vcd testbench_verilator
