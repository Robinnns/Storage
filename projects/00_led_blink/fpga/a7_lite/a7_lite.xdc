# ============================================================
# A7-LITE 板级约束 (板卡绑定, 与设计解耦)
# 来源: A7-LITE 参考手册 + MicroPhase/fpga-docs 原理图
# ⚠️ 使用前务必对照板卡原理图核对引脚号!
#   原理图: https://github.com/MicroPhase/fpga-docs/blob/master/schematic/A7-LITE_R11.pdf
#   参考手册: https://fpga-docs.microphase.cn/en/latest/DEV_BOARD/A7-LITE/A7-Lite_Reference_Manual.html
# ============================================================

# ---- 系统时钟 (50MHz 有源晶振) ----
set_property PACKAGE_PIN J19  [get_ports clk_50m]
set_property IOSTANDARD LVCMOS33 [get_ports clk_50m]

# ---- 用户 LED ----
set_property PACKAGE_PIN M18  [get_ports led1]
set_property IOSTANDARD LVCMOS33 [get_ports led1]

set_property PACKAGE_PIN N18  [get_ports led2]
set_property IOSTANDARD LVCMOS33 [get_ports led2]

# ---- 复位按键 (KEY1, 按下为低) ----
set_property PACKAGE_PIN AA1  [get_ports rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]

# ---- 时钟约束 (50MHz → 周期 20ns) ----
create_clock -period 20.000 -name sys_clk [get_ports clk_50m]

# ---- 可选的输入滤波/去抖 (点灯工程可不加) ----
# set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets clk_50m]
