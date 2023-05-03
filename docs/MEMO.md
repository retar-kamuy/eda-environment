# Memo

## testbench.cpp
* iverilog 用テストベンチ [testbench.sv](testbench.sv) をラッパーする Verilator 用テストベンチ
* 以下が `testbench.sv` を Verilator が実行時に vcd へダンプするための記述

```verilog
3: #include "verilated_vcd_sc.h"    // ダンプ用インクルードファイル

14:	sc_start(0, SC_NS); // trace() 実行前に sc_start が必要なため追加

20: const char* flag_vcd = Verilated::commandArgsPlusMatch("trace");    // varilator コマンド実行時に `--trace` オプションを付けることでダンプできるようにする
21:	if (flag_vcd && 0==strcmp(flag_vcd, "+trace")) {    // バイナリ実行時に `+trace` を付けることでダンプできるようにする
22:		Verilated::traceEverOn(true);
23:		tfp = new VerilatedVcdSc;   // SystemC 用記述。C++ の場合は `VerilatedVcdC`
24:		top->trace (tfp, 99);
25:		tfp->open("testbench.vcd");
26:	}

28: while (!Verilated::gotFinish()) {   // verilog テストベンチで `$finish` が実行されるまで `sc_start` を繰り返す
29:     sc_start(1, SC_NS);
30: }
31:
32:	top->final();
33:
34: if (tfp) tfp->close();
```
