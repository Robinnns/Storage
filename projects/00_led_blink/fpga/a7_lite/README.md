# A7-LITE 板卡支持包（BSP）

本目录存放与 **Microphase A7-LITE 板卡**绑定的一切信息，与设计源码（`src/`）解耦。
换板卡时复制本目录为 `fpga/<新板卡名>/`，设计代码无需改动。

## 板卡资料链接

- **原理图 PDF**：[A7-LITE_R11.pdf](https://github.com/MicroPhase/fpga-docs/blob/master/schematic/A7-LITE_R11.pdf)
- **参考手册**：[fpga-docs.microphase.cn](https://fpga-docs.microphase.cn/en/latest/DEV_BOARD/A7-LITE/A7-Lite_Reference_Manual.html)
- **官方文档仓库**：[MicroPhase/fpga-docs](https://github.com/MicroPhase/fpga-docs)

## 本目录内容

| 文件 | 说明 |
|------|------|
| `a7_lite.xdc` | 板级约束：引脚分配 + 时钟约束（Vivado 直接引用） |
| `pinmap.md` | 自整理的引脚速查表（可提交 git） |

## 核对记录

- [ ] 引脚分配已对照原理图核对（LED/时钟/复位）
- [ ] EEPROM 型号已确认（丝印 / 原理图）
