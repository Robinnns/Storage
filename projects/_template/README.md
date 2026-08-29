# 工程模板 `_template`

> 新建工程一律从本模板复制，保证所有工程结构统一。参考实现见 `00_led_blink/`。

## 使用方法

```bash
# 在 projects/ 下复制模板
cp -r _template 01_logic_gates
cd 01_logic_gates
```

然后按顺序：
1. 写 RTL → `rtl/`，写 testbench → `tb/`
2. 建板卡 BSP → `fpga/a7_lite/`（参考 `00_led_blink/fpga/a7_lite/`，放 xdc / pinmap / README）
3. 编辑 `eda/vivado/scripts/create_project.tcl` 里的 **工程参数**（工程名、顶层模块、文件列表）
4. 编辑 `eda/iverilog/scripts/run_sim.bat`（若 testbench 顶层不叫 `tb_top`）
5. 重写 `README.md`（参照 `00_led_blink/README.md`）
6. 更新根目录 `plans/roadmap-a7lite.md` 的对应阶段与产出

## 目录结构约定

```
NN_xxx/
├── rtl/                  # RTL 源码            ← 与板卡/工具解耦, git 提交
├── tb/                   # testbench           ← git 提交
├── fpga/<板卡名>/         # 板卡 BSP 层          ← xdc/pinmap/README, git 提交
├── eda/
│   ├── vivado/
│   │   ├── scripts/      # TCL 自动化脚本       ← git 提交
│   │   └── workspace/    # Vivado 工程实体      ← Windows 生成, gitignore
│   └── iverilog/
│       ├── scripts/      # run_sim.bat          ← git 提交
│       └── workspace/    # 仿真产物             ← gitignore
└── doc/                  # 工程笔记 / 截图
```

## 三原则

1. **三层解耦**：设计（`rtl/` `tb/`）不依赖板卡和工具；换板卡只动 `fpga/`，换工具链只动 `eda/`。
2. **不提交 `.xpr`**：工程由 `create_project.tcl` 一键重建（相对路径引用外部源码），`.xpr`、`.bit` 等生成物已被根 `.gitignore` 忽略。首次体验手动建工程后，用 `write_project_tcl` 导出脚本替代手动流程。
3. **源码可移植**：macOS 写源码提交 git，Windows `source scripts/create_project.tcl` 直接建工程；轻量功能验证用 iverilog，综合/时序用 Vivado。
