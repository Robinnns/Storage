# 学习会话日志

> 每完成一次会话，追加一行。格式：`YYYY-MM-DD | 做了什么 | 卡在哪 | 下次做什么`

## 2026-08-29 | 启动阶段 0（点灯工程）
- 确认 A7-LITE 板载资源（DDR3 MT41K256M16 / QSPI IS25L128F / 50MHz时钟 / LED M18,N18 / 时钟 J19）
- 确认双环境工作流（macOS 写源码 ↔ GitHub ↔ Windows 跑 Vivado）
- 规划并创建 `projects/00_led_blink/` 工程骨架（src/sim/constr/scripts/doc/vivado）
- 写好 `src/top.v`（26-bit 计数器点灯）、`sim/tb_top.v`、`constr/a7lite.xdc`
- **待办（用户侧）：** Windows 装 Vivado 2021.1 + Git；下载板卡原理图核对引脚；确认 EEPROM 型号
- **下次：** 用户同步仓库到 Windows → 建 Vivado 工程 → 行为仿真 → 生成 bitstream → 下载验证

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
