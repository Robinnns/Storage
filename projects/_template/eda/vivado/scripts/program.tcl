# ============================================================
# program.tcl — 下载 bitstream 到 FPGA (模板版)
#
# 前置: 1) 已 Generate Bitstream 成功  2) 板卡 JTAG 已连接上电
#
# 用法 (Vivado GUI 内):
#   Hardware Manager → Open Target → Auto Connect
#   source eda/vivado/scripts/program.tcl
# ============================================================

# 0) 工程参数 ← 复制后修改
set proj_name  PROJECT_NAME          ;# 工程名
set top_module TOP_MODULE            ;# 顶层模块名 (bit 文件名以此命名)

# 定位工程根目录
set script_dir [file dirname [file normalize [info script]]]
set root_dir   [file normalize [file join $script_dir .. .. ..]]

set bit_file [file normalize \
    [file join $root_dir eda vivado workspace ${proj_name}.runs impl_1 ${top_module}.bit]]

if {![file exists $bit_file]} {
    error "未找到 bitstream: $bit_file
请先在 Vivado 中 Generate Bitstream."
}

open_hw_manager
connect_hw_server
open_hw_target
current_hw_device [lindex [get_hw_devices] 0]
set_property PROGRAM.FILE $bit_file [current_hw_device]
program_hw_devices [current_hw_device]

puts "==> 下载完成: $bit_file"
