# ============================================================
# program.tcl — 下载 bitstream 到 A7-LITE
#
# 前置条件:
#   1. 已 Generate Bitstream 成功 (workspace/00_led_blink.runs/impl_1/top.bit)
#   2. 板卡 JTAG 已通过 USB 连接并上电
#
# 用法 (Vivado GUI 内):
#   Hardware Manager → Open Target → Auto Connect
#   Tcl Console: source eda/vivado/scripts/program.tcl
#
# 或命令行批量模式:
#   vivado -mode batch -source eda/vivado/scripts/program.tcl
# ============================================================

# 定位工程根目录
set script_dir [file dirname [file normalize [info script]]]
set root_dir   [file normalize [file join $script_dir .. .. ..]]

set bit_file [file normalize \
    [file join $root_dir eda vivado workspace 00_led_blink.runs impl_1 top.bit]]

if {![file exists $bit_file]} {
    error "未找到 bitstream: $bit_file
请先在 Vivado 中 Generate Bitstream (Run Synthesis → Run Implementation → Generate Bitstream)."
}

open_hw_manager
connect_hw_server
open_hw_target

# 选中第一个检测到的器件 (通常是 7a35t)
current_hw_device [lindex [get_hw_devices] 0]

set_property PROGRAM.FILE $bit_file [current_hw_device]
program_hw_devices [current_hw_device]

puts "==> 下载完成: $bit_file"
