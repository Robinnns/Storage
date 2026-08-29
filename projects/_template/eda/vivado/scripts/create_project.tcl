# ============================================================
# create_project.tcl — 一键创建 Vivado 工程 (模板版)
#
# 使用: 复制模板为 projects/NN_xxx/ 后, 修改下面的【工程参数】,
#      以及 add_files 的文件列表, 即可在任意机器一键重建工程.
#
# 用法 (Windows, 二选一):
#   方式 A — Vivado GUI 内:
#     cd <仓库>\projects\NN_xxx\eda\vivado
#     source scripts/create_project.tcl
#   方式 B — 命令行:
#     vivado -mode batch -source scripts/create_project.tcl
#
# 若 workspace/ 已有旧工程, 先删除该目录再运行.
# ============================================================

# 0) 工程参数 ← 复制后修改这里
set proj_name  PROJECT_NAME          ;# 工程名 (建议 = 目录名)
set top_module TOP_MODULE            ;# 顶层模块名
set part       xc7a35tfgg484-2       ;# A7-LITE 器件

# 定位工程根目录 (scripts/ -> vivado/ -> eda/ -> 工程根)
set script_dir [file dirname [file normalize [info script]]]
set root_dir   [file normalize [file join $script_dir .. .. ..]]

puts "==> 工程根目录: $root_dir"
puts "==> 顶层模块: $top_module"

# 1) 创建工程 (实体目录: eda/vivado/workspace/)
create_project $proj_name [file join $script_dir .. workspace] -part $part

# 2) 添加 RTL 源码 (src/ 下所有 .v, 按需增删)
add_files -norecurse [file glob [file join $root_dir src *.v]]

# 3) 添加板级约束 (改为你的板卡 BSP 路径)
add_files -fileset constrs_1 -norecurse [file join $root_dir fpga a7_lite a7_lite.xdc]

# 4) 添加仿真源文件 (sim/ 下所有 .v)
add_files -fileset sim_1 -norecurse [file glob [file join $root_dir sim *.v]]

# 5) 设置顶层模块
set_property top $top_module [current_fileset]
set_property top_lib xil_defaultlib [current_fileset]

# 6) 保存并关闭
save_project_as $proj_name [file join $script_dir .. workspace] -force
close_project

puts "==> 完成! 工程已创建于 eda/vivado/workspace/"
puts "==> 下一步: Run Behavioral Simulation 或 Generate Bitstream"
