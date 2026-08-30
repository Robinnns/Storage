# ============================================================
# A7-LITE 板级约束 (工程裁剪版, 板卡绑定, 与设计解耦)
# 来源: 厂家官方 xdc (a7_lite_official.xdc), 引脚已核对
#   官方全量引脚见同目录 a7_lite_official.xdc (含版权, 不入库)
# ============================================================

# ---- 系统时钟 (50MHz 有源晶振) ----
set_property PACKAGE_PIN J19  [get_ports clk_50m]
set_property IOSTANDARD LVCMOS33 [get_ports clk_50m]

# ---- 用户 LED ----
set_property PACKAGE_PIN M18  [get_ports led1]
set_property IOSTANDARD LVCMOS33 [get_ports led1]

set_property PACKAGE_PIN N18  [get_ports led2]
set_property IOSTANDARD LVCMOS33 [get_ports led2]

# ---- 复位 (板载专用 RESET 引脚, 低有效) ----
set_property PACKAGE_PIN L18  [get_ports rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]

# ---- UART 发送 (FPGA → CH340 → USB 串口) ----
set_property PACKAGE_PIN V2  [get_ports uart_tx]
set_property IOSTANDARD LVCMOS33 [get_ports uart_tx]

# ---- 时钟约束 (50MHz → 周期 20ns) ----
create_clock -period 20.000 -name sys_clk [get_ports clk_50m]

# ---- 可选的输入滤波/去抖 (点灯工程可不加) ----
# set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets clk_50m]
