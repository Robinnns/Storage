# A7-LITE 结合实践学习路径

> **平台：** Microphase A7-LITE · XC7A35T-2FGG484 · Vivado 2021.1
> **目标：** 把已学的存储理论（SRAM/DRAM/NOR/NAND/DDR）逐一落到真实硬件
> **节奏：** 每周 **10 小时** · 已跳过阶段 1/2（基础技能并入阶段 3）· 全程约 **6–8 周**
> **调整记录：** 2026-08-30 跳过阶段 1/2；每周投入由 3–5h 改为 10h

---

## 硬件资源 ↔ 已学知识点映射

| 存储资源 | 型号 | 规格 | 对应知识点 | 知识点笔记 |
|---------|------|------|-----------|-----------|
| DDR3 SDRAM | MT41K256M16 | 256M×16 = 512MB · 1066Mbps | DRAM 1T1C、DDR 命令时序、Row Buffer | `lessons/0002-dram-cell.html` |
| QSPI Flash | IS25L128F | 128Mbit = 16MB | NOR Flash、页/扇区/擦除 | `knowledges/260801_DRAM-word-page-burst.html` |
| EEPROM | BL24C128A（上海贝岭，兼容 AT24C128） | 128Kbit=16KB · 64B 页写 · I2C | 存储接口、I2C | — |
| Micro SD | 卡槽 | SD/SPI 模式 | 块寻址、存储系统 | — |
| FPGA BRAM | 50 × 36Kb = 1.8Mb | SRAM 硬核 | SRAM 阵列结构 | `knowledges/260731_SRAM-array-structure.html` |
| 分布式 RAM | 400Kb | LUT 实现 | SRAM vs BRAM | `knowledges/260731_FPGA-architecture.html` |

---

## 阶段 0 · 环境搭建 ✅

- [x] 安装 Vivado 2021.1（板卡官方推荐版本）
- [x] 下载板卡约束文件（MicroPhase/fpga-docs，`a7_lite_official.xdc`）
- [x] 创建第一个工程，点亮板载 LED（D6/D5）
- [x] 跑通 USB-UART（CH340），串口打印 "Hello"（仿真 + 上板确认 ✅）

**验收：** LED 闪烁 ✅ · 串口输出 ✅（iverilog 仿真 + 上板实测）
**产出：** `projects/00_led_blink/`

---

## 阶段 1·2 · 组合/时序基础 — 已跳过 ✅（技能并入阶段 3）

> **为什么能跳：** 点灯工程已覆盖计数器（时序基础）+ always/reg/assign；LUT/DFF 理论已有笔记。
> **不白跳：** 三项关键技能下沉到阶段 3 的「前置热身」——① 综合报告解读（LUT 概念）② ILA 使用（时序抓波）③ BRAM 综合报告对比（原本阶段 1 的 Utilization 报告技能）。

---

## 阶段 3 · BRAM（含前置热身）⏳ 1–1.5 周 @10h

- [ ] **热身 A（原阶段 1 技能）：** 综合 BRAM 测试工程 → 打开 Synthesis Utilization 报告，看懂 LUT / FF / BRAM 三列，记录用量
- [ ] **热身 B（原阶段 2 技能）：** 用 ILA 抓 BRAM 读写波形（内部信号直接观察）
- [ ] 用 `reg [7:0] mem [0:255]` 写 inferred BRAM（读 + 写）
- [ ] 对比综合报告：inferred BRAM 用了几块 36Kb
- [ ] 用 BRAM IP（XPM 或 Block Memory Generator）建真双口 RAM
- [ ] 实现一个同步 FIFO（用 BRAM），验证空/满标志

**理论衔接：** 「SRAM 阵列结构」「FPGA 内部资源」——BRAM 就是 FPGA 里的 SRAM 硬核，读写时序和理论一致
**验收：** 双口 RAM 两端口独立读写正确 + FIFO 空满正确 + 会用 ILA / 能读综合报告
**产出：** `projects/03_bram_fifo/`

---

## 阶段 4 · I2C EEPROM ⏳ 1–1.5 周 @10h

- [x] 确认板载 EEPROM 型号（BL24C128A，丝印确认）
- [ ] 手写 I2C Master（含 SCL 生成、START/STOP、ACK 检测）
- [ ] 读写 EEPROM：写一个字节 → 回读 → UART 打印
- [ ] （进阶）实现页写入（Page Write，64B/页）

**理论衔接：** 第一次操作真实存储芯片——理解字节寻址、设备地址（1010 A2 A1 A0）、ACK
**验收：** 断电重启后数据仍在（验证 EEPROM 非易失）
**产出：** `projects/04_i2c_eeprom/`

---

## 阶段 5 · QSPI Flash ⏳ 1 周 @10h

- [ ] 用 QSPI 控制器读 JEDEC ID（确认是 IS25L128F）
- [ ] 实现 Sector Erase → Page Program → Read
- [ ] 写入一串数据再回读，比对一致性
- [ ] 观察并记录：写 vs 读 的速度差异

**理论衔接：** NOR Flash 特性验证——QSPI Flash 就是 NOR Flash，「读快写慢、按扇区擦除、擦除前要先擦」全部能实测
**验收：** 回读数据一致 + 能说出本板 Flash 的擦除粒度（扇区大小）
**产出：** `projects/05_qspi_flash/`

---

## 阶段 6 · DDR3 + MIG ★ 重点 ⏳ 1.5–2 周 @10h

- [ ] 用 MIG IP（Memory Interface Generator）生成 DDR3 控制器
  - 参考 A7-LITE 板卡约束 / 官方 MIG 示例，配置 512MB、16-bit、1066Mbps
- [ ] 通过 AXI 接口做读写回环测试（Write → Read → 比对）
- [ ] 用 ILA 抓取 DDR3 引脚波形，**观察并截图**：
  - [ ] ACTIVATE 命令（行激活）
  - [ ] READ / WRITE（列访问，数据与 DQS 对齐）
  - [ ] PRECHARGE（预充电）
  - [ ] REFRESH（刷新命令周期性出现）
- [ ] 测量并记录：行激活到数据返回的延迟、刷新间隔

**理论衔接：** ★ 系统集成工作的核心——「DRAM 破坏性读取 → tRC」「刷新 → 延迟尖峰」用示波器/ILA 亲眼看到
**验收：** 读写 1MB 数据 100% 比对一致 + 抓到的关键波形
**产出：** `projects/06_ddr3_mig/`

---

## 阶段 7 · 综合项目 ⏳ 1.5 周 @10h

选择其一：

**选项 A — DDR3 帧缓冲 + HDMI 显示**
- [ ] HDMI 输出一个彩色测试图
- [ ] 把图像数据写入 DDR3，再从 DDR3 读出 → HDMI 显示
- [ ] 验证「数据在 DRAM 中走了一个来回」

**选项 B — 简易存储子系统**
- [ ] MicroBlaze 软核 + DDR3 + QSPI + UART 打通
- [ ] 软核从 QSPI 启动，DDR3 作为主存，UART 交互
- [ ] 验证从 Flash 引导到内存执行

**理论衔接：** 把整个存储体系（Flash 持久化 + DRAM 高速缓存 + 控制器）串起来
**验收：** 可演示的完整工程
**产出：** `projects/07_final_project/`

---

## 双环境工作流

```
macOS（当前）                    Windows（FPGA）
┌──────────────────────┐         ┌──────────────────────┐
│ 写 RTL 源码 (Verilog) │         │ 仿真 (行为/时序)      │
│ 写约束文件/笔记       │  GitHub  │ 综合/实现 (Vivado)    │
│ 管理 git / 文档       │ ──────→ │ 下载/JTAG 调试        │
│ 提交推送 (用户决定)   │         │ MIG 生成 / ILA 抓波形  │
└──────────────────────┘         └──────────────────────┘
```

**流程约定：** 源码在 macOS 写好 → commit+push → Windows pull → 跑 Vivado → 发现问题回 macOS 改 → 循环。

## 工具链速查

| 工具 | 用途 | 环境 | 链接 |
|------|------|------|------|
| Vivado 2021.1 | 综合/实现/下载/调试 | **Windows** | xilinx.com/download |
| MIG IP | DDR3 内存控制器生成器 | **Windows**（Vivado 内） | Vivado 自带 |
| ILA IP | 片内逻辑分析仪（抓 BRAM/DDR3 波形） | **Windows**（Vivado 内） | Vivado 自带 |
| GTKWave | 仿真波形查看（配 Icarus） | **Windows** 或 macOS | gtkwave.sourceforge.net |
| Surfer | 波形查看（iverilog 搭档） | **macOS**（brew） | surfer.rtfd.io |
| VS Code | 写 RTL 源码（Verilog 插件） | **macOS** | code.visualstudio.com |
| Icarus Verilog | 轻量仿真（秒级快速验证） | 两环境均可 | iverilog.icarus.com |

**推荐教程：**
- A7-LITE 官方文档：[fpga-docs.microphase.cn](https://fpga-docs.microphase.cn/en/latest/DEV_BOARD/A7-LITE/A7-Lite_Reference_Manual.html)
- Digilent Arty A7 教程（同款 XC7A35T，参考性强）：[learn.digilent.com](https://learn.digilent.com)
- Vivado 上手：[AMD 官方视频教程](https://www.amd.com/en/training)

---

## 进度记录

| 阶段 | 开始日期 | 完成日期 | 备注 |
|------|---------|---------|------|
| 0 环境 | 2026-08-29 | 2026-08-30 | ✅ 全通过：点灯 + UART 上板确认 |
| 1-2 组合/时序 | — | — | 跳过，技能并入阶段 3 |
| 3 BRAM | — | — | 预计 1–1.5 周（含 LUT/ILA 热身） |
| 4 EEPROM | — | — | 预计 1–1.5 周 |
| 5 QSPI Flash | — | — | 预计 1 周 |
| 6 DDR3 | — | — | 预计 1.5–2 周 |
| 7 综合项目 | — | — | 预计 1.5 周 |

**总预计：** 约 6–8 周（每周 10 小时）
