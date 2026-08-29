# 00_led_blink — A7-LITE 点灯工程

阶段 0 的入门工程：用 26-bit 计数器分频 50MHz 时钟，驱动两个板载 LED 交替闪烁。

## 目录结构（工程统一约定）

```
00_led_blink/
├── rtl/                  # RTL 源码            ← 与板卡/工具解耦
│   └── top.v             #   26-bit 计数器点灯
├── tb/                   # testbench
│   └── tb_top.v
├── fpga/                 # 板卡相关 (BSP 层)
│   └── a7_lite/
│       ├── a7_lite.xdc   # 板级约束: 引脚 + 时钟
│       ├── pinmap.md     # 引脚速查表
│       └── README.md     # 板卡资料链接
├── eda/                  # EDA 工具相关
│   ├── vivado/
│   │   ├── scripts/
│   │   │   ├── create_project.tcl   # 一键重建 Vivado 工程
│   │   │   └── program.tcl          # 下载 bitstream 到板卡
│   │   └── workspace/    # Vivado 工程实体 (Windows 生成, 不入库)
│   └── iverilog/
│       ├── scripts/run_sim.bat      # 一键 iverilog 仿真
│       └── workspace/    # 仿真产物 (不入库)
└── doc/                  # 工程笔记 / 波形截图
```

**核心思想：** 设计（`rtl/` `tb/`）与 板卡（`fpga/`）与 工具（`eda/`）三层解耦。
macOS 写源码 → 提交 git → Windows 一条 TCL 命令重建工程。

## Windows 上建工程（推荐：TCL 一键）

```bash
# 方式 A — Vivado GUI 内: 打开 Vivado 2021.1 → Tcl Console
cd <仓库>\projects\00_led_blink\eda\vivado
source scripts/create_project.tcl

# 方式 B — 命令行批量模式:
vivado -mode batch -source scripts/create_project.tcl
```

脚本自动完成：建工程（器件 `xc7a35tfgg484-2`）→ 引用 `rtl/`、`tb/`、`fpga/a7_lite/` 外部文件 → 设顶层 `top` → 保存到 `workspace/`。

建好后依次：
1. **Run Behavioral Simulation** — 验证 RTL
2. **Generate Bitstream** — 综合 → 实现 → 生成 `.bit`
3. 连接板卡 → **Hardware Manager → Open Target → Auto Connect**
4. 下载：`source scripts/program.tcl`

## 手动建工程步骤（脚本异常时的兜底）

1. Vivado 2021.1 → Create Project，工程名 `00_led_blink`，位置选 `eda/vivado/workspace/`
2. Add Sources → Add Directories → 选 `rtl/`
3. Add Constraints → Add Files → 选 `fpga/a7_lite/a7_lite.xdc`
4. Add Simulation Sources → Add Files → 选 `tb/tb_top.v`
5. 器件 `xc7a35tfgg484-2` → 顶层 `top` → 保存
6. Run Simulation → Generate Bitstream → Hardware Manager → Program Device

**建好后导出为 TCL 脚本**（让手动成果可复用、可移植）：

```tcl
# 工程打开状态下, 在 Vivado Tcl Console 中:
cd <仓库>\projects\00_led_blink
write_project_tcl -force -no_copy_sources -paths_relative_to . eda/vivado/scripts/created_from_gui.tcl
```

- `-paths_relative_to .` → 路径写成相对于当前目录，跨机器可移植（同盘符内）
- `-no_copy_sources` → 不复制源码，保持引用
- 打开生成的 `.tcl` 对比 `create_project.tcl`，看 Vivado 自动生成了什么
- 以后重建：`source eda/vivado/scripts/created_from_gui.tcl`

> ⚠️ 若引脚约束与实际板卡不符，对照 [A7-LITE 原理图](https://github.com/MicroPhase/fpga-docs/blob/master/schematic/A7-LITE_R11.pdf) 修改 `fpga/a7_lite/a7_lite.xdc`。

## 快速仿真（可选）

**Windows：** 直接运行 `eda/iverilog/scripts/run_sim.bat` —— 一键编译 + 运行 + 导出波形，产物在 `eda/iverilog/workspace/`，详见 `eda/iverilog/README.md`。

**macOS / 其他平台（需装 Icarus Verilog）：**

```bash
iverilog -g2012 -o tb.vvp rtl/top.v tb/tb_top.v
vvp tb.vvp
```

> 注意：完整 26-bit 计数器翻转需 ~1.34s，行为仿真观察不到翻转。想看翻转就临时把 `top.v` 里的计数器改小（如 8-bit），或只用仿真验证信号连接正确。
