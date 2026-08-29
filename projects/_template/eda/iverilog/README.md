# iverilog 仿真工作流（模板）

轻量 RTL 功能验证用，与 Vivado xsim 互补。完整说明参考 `00_led_blink/eda/iverilog/README.md`。

- `scripts/run_sim.bat` — 一键编译 + 运行 + 导出 VCD（**入库**）
- `workspace/` — 仿真产物（**不入库**，根 `.gitignore` 忽略）

```bash
eda/iverilog/scripts/run_sim.bat
gtkwave eda/iverilog/workspace/top_tb.vcd   # 若已装 GTKWave
```

> 若你的 testbench 顶层模块不叫 `tb_top`，改 `run_sim.bat` 里的 `set TOP=...`。
