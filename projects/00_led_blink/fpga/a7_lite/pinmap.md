# A7-LITE 引脚速查表

> **核对状态：✅ 已对照厂家官方 xdc（`a7_lite_official.xdc`）核对** —— 引脚全部一致。
> 本表是自整理的板卡引脚索引，随工程使用不断补充。

## 点灯工程用到的引脚（`a7_lite.xdc`）

| 信号 | 引脚 | IO 标准 | 方向 | 说明 |
|------|------|---------|------|------|
| clk_50m | J19 | LVCMOS33 | in | 50MHz 有源晶振 |
| led1 | M18 | LVCMOS33 | out | 用户 LED1 |
| led2 | N18 | LVCMOS33 | out | 用户 LED2 |
| rst_n | L18 (RESET) | LVCMOS33 | in | 板载专用复位，低有效 |

## 厂家官方版全部引脚（`a7_lite_official.xdc`，权威字典）

### 时钟 / 复位 / 按键
| 信号 | 引脚 | 说明 |
|------|------|------|
| CLK_50M | J19 | 50MHz 晶振 |
| **RESET** | **L18** | 板载专用复位（点灯工程在用） |
| KEY1 / KEY2 | AA1 / W1 | 用户按键 |

### LED
| 信号 | 引脚 |
|------|------|
| LED1 / LED2 | M18 / N18 |

### 外设（后续阶段用）
| 模块 | 引脚 |
|------|------|
| EEPROM_I2C_SCL / SDA | **J22 / H22**（阶段 4） |
| UART_RX / UART_TX | U2 / V2（阶段 0 串口） |
| SD_CLK / SD_CMD / SD_DATA0-3 | U7 / AA8 / W9,Y9,Y7,Y8 |
| HDMI1_CLK_P / D0_P / D1_P / D2_P | L19 / K21 / J20 / G17（TMDS_33） |
| HDMI1_HPD_CON | H15 |
| ETH_nRST / MDC / MDIO | N22 / M22 / M20 |
| ETH_RXCK / RXCTL / RXD[3:0] | K18 / K19 / M16,L16,M15,L14 |
| ETH_TXCK / TXCTL / TXD[3:0] | K17 / N20 / M13,L13,L15,K16 |

## 板载资源（供后续阶段参考）

| 资源 | 型号 | 规格 | 用途阶段 |
|------|------|------|---------|
| DDR3 SDRAM | MT41K256M16 | 256M×16 = 512MB · 1066Mbps | 阶段 6 (MIG) |
| QSPI Flash | IS25L128F | 128Mbit = 16MB | 阶段 5 |
| EEPROM | 型号丝印待确认（I2C 引脚已确认 J22/H22） | 字节寻址 | 阶段 4 |
| Micro SD 卡槽 | — | SD/SPI 模式 | 阶段 7 |
| USB-UART | CH340 | 串口 | 阶段 0 |
