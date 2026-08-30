# 学习会话日志

> 每完成一次会话，追加一行。格式：`YYYY-MM-DD | 做了什么 | 卡在哪 | 下次做什么`

## 2026-08-29 | 启动阶段 0（点灯工程）
- 确认 A7-LITE 板载资源（DDR3 MT41K256M16 / QSPI IS25L128F / 50MHz时钟 / LED M18,N18 / 时钟 J19）
- 确认双环境工作流（macOS 写源码 ↔ GitHub ↔ Windows 跑 Vivado）
- 规划并创建 `projects/00_led_blink/` 工程骨架（src/sim/constr/scripts/doc/vivado）
- 写好 `src/top.v`（26-bit 计数器点灯）、`sim/tb_top.v`、`constr/a7lite.xdc`
- **待办（用户侧）：** Windows 装 Vivado 2021.1 + Git；下载板卡原理图核对引脚；确认 EEPROM 型号
- **下次：** 用户同步仓库到 Windows → 建 Vivado 工程 → 行为仿真 → 生成 bitstream → 下载验证

## 2026-08-30 | 🏁 阶段 0 全部完成：上板串口确认 "Hello World!"
- Windows 上板下载成功，串口 115200 循环收到 "Hello World!" ✅
- 阶段 0 验收全通过：LED 点灯 ✅ + UART 串口 ✅
- Windows 实测发现 create_project.tcl 的 Tcl 语法错误（file glob→glob）并修复，双环境闭环验证价值体现
- **下一步：** 进入阶段 1（组合逻辑 → LUT）

## 2026-08-30 | 阶段 0 收官：UART 串口 "Hello World!"（仿真）
- 实现 `rtl/uart_tx.v`（参数化波特率，8-N-1 帧状态机）+ top 集成循环发送
- **修复一拍竞态**：发送控制只判 `!tx_busy` 会在 uart_tx 启动空隙重复触发 → 跳字符；加 `!tx_start` 条件解决（iverilog 仿真发现的）
- macOS 装 iverilog（brew icarus-verilog 13.0），仿真输出完整 "Hello World!" ✅
- 更新 xdc（uart_tx=V2）、create_project.tcl（rtl glob 纳入新模块）、README（串口步骤）
- **待办：** Windows 上板下载 + 串口工具确认 → 阶段 0 全完成 → 进阶段 1

## 2026-08-30 | 🎉 阶段 0 里程碑：点灯成功
- 目录重命名 `src→rtl`、`sim→tb`（更符合业界惯例）
- 新增 `eda/iverilog/` 轻量仿真工作流（run_sim.bat + 详细 README + VCD 条件编译）
- 复位改用厂家专用 `RESET(L18)`；厂家 xdc 归档为 `a7_lite_official.xdc` 并 gitignore
- **上板下载成功，LED1/LED2 交替闪烁 ✅**
- `_template` 已同步 rtl/tb 命名 + iverilog 骨架
- **待办：** UART 串口 "Hello"；EEPROM 型号丝印；进入阶段 1（组合逻辑 → LUT）

## 2026-08-29 | 决策：.xpr 不入库，手动体验后导出脚本
- 讨论 `.xpr` 本质（XML 工程索引，不含源码）与 Vivado 相对路径机制（PATH_MODE / Enable relative paths，跨盘符失效）
- 用户选择：手动建工程体验一次 → `write_project_tcl` 导出 TCL → 日常仍用 `create_project.tcl` 自动化
- `.gitignore` 保持忽略 `*.xpr`，无需改动

## 2026-08-29 | 重构工程结构为 fpga/eda 三层解耦
- `00_led_blink` 重构：设计(`src/` `sim/`) | 板卡(`fpga/a7_lite/`) | 工具(`eda/vivado/`) 解耦
- 新增 `eda/vivado/scripts/{create_project,program}.tcl` — Windows 一条命令重建工程，**不再提交 `.xpr`**
- 创建 `projects/_template/` 工程模板，模板约定固化进 `NOTES.md`
- `.gitignore` 新增忽略 `*.xpr` `*.bit` `*.bin` `*.ltx`
- **下次：** 用户同步仓库到 Windows → `source scripts/create_project.tcl` 建工程 → 仿真 → bitstream → 下载
