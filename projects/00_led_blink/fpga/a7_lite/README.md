# A7-LITE 板卡支持包（BSP）

本目录存放与 **Microphase A7-LITE 板卡**绑定的一切信息，与设计源码（`rtl/`）解耦。
换板卡时复制本目录为 `fpga/<新板卡名>/`，设计代码无需改动。

## 板卡资料链接

- **原理图 PDF**：[A7-LITE_R11.pdf](https://github.com/MicroPhase/fpga-docs/blob/master/schematic/A7-LITE_R11.pdf)
- **参考手册**：[fpga-docs.microphase.cn](https://fpga-docs.microphase.cn/en/latest/DEV_BOARD/A7-LITE/A7-Lite_Reference_Manual.html)
- **官方文档仓库**：[MicroPhase/fpga-docs](https://github.com/MicroPhase/fpga-docs)

## 本目录内容

| 文件 | 说明 |
|------|------|
| `a7_lite.xdc` | **工程裁剪约束**：本工程引脚 + `create_clock`（Vivado 实际引用） |
| `a7_lite_official.xdc` | **厂家官方全量**：所有外设引脚权威定义（含版权头） |
| `pinmap.md` | 自整理的引脚速查表（已对照官方版核对） |

> **两个 xdc 的分工**：工程只引用裁剪版 `a7_lite.xdc`（端口名匹配 RTL 小写 + 补了厂家缺的 `create_clock`）。官方版是权威字典，供核对和未来外设工程复用，**不要同时加入一个工程**（端口名不同会重复约束）。

> ✅ **版权处理**：`a7_lite_official.xdc` 含 MicroPhase 版权声明（"未经书面许可不得发布"），已加入根 `.gitignore` 不入库，仅本地保留。

## 核对记录

- [x] 引脚分配已对照厂家官方 xdc 核对（LED/时钟/复位全部一致）
- [x] EEPROM 型号已确认（BL24C128A，丝印）
