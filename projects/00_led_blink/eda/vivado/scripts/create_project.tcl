# ============================================================
# create_project.tcl — 一键创建 00_led_blink Vivado 工程
#
# 设计思路:
#   - 源码 (rtl/ tb/ fpga/) 由 macOS 编写、提交 git
#   - 本脚本用【相对路径】引用这些外部文件, 不复制进工程
#   - 工程实体生成在 eda/vivado/workspace/ (已被 .gitignore 忽略)
#   - 因此换机器/换路径都能一键重建, 无需提交 .xpr
#
# 用法 (Windows, 二选一):
#   方式 A — Vivado GUI 内:
#     打开 Vivado 2021.1 → Tcl Console →
#     cd <仓库>\projects\00_led_blink\eda\vivado
#     source scripts/create_project.tcl
#
#   方式 B — 命令行批量模式 (先在 vivado/ 目录下运行, 避免日志写进仓库根):
#     cd <仓库>\projects\00_led_blink\eda\vivado
#     vivado -mode batch -nolog -nojournal -source scripts/create_project.tcl
#     (-nolog -nojournal 禁用 vivado.log/jou; .Xil/ 仍写当前目录, 已被 .gitignore 忽略)
#
# 若 workspace/ 已有旧工程, 先删除该目录再运行.
# ============================================================

# 0) 定位路径 (脚本所在目录 -> 工程根目录)
set script_dir [file dirname [file normalize [info script]]]
#   scripts/  ->  vivado/  ->  eda/  ->  00_led_blink/
set root_dir   [file normalize [file join $script_dir .. .. ..]]

set proj_name  00_led_blink
set part       xc7a35tfgg484-2

puts "==> 工程根目录: $root_dir"
puts "==> 器件: $part"

# 1) 创建工程 (实体目录: eda/vivado/workspace/)
create_project $proj_name [file join $script_dir .. workspace] -part $part

# 2) 添加 RTL 源码 (rtl/ 下所有 .v, 新增模块自动纳入)
add_files -norecurse [glob [file join $root_dir rtl *.v]]

# 3) 添加板级约束 (fpga/a7_lite/)
add_files -fileset constrs_1 -norecurse [file join $root_dir fpga a7_lite a7_lite.xdc]

# 4) 添加仿真源文件 (tb/)
add_files -fileset sim_1 -norecurse [file join $root_dir tb tb_top.v]

# 5) 设置顶层模块
set_property top top [current_fileset]
set_property top_lib xil_defaultlib [current_fileset]

# 6) 关闭 (add_files/set_property 时 Vivado 已自动保存 .xpr)
close_project

puts "==> 完成! 工程已创建于 eda/vivado/workspace/"
puts "==> 下一步: Run Behavioral Simulation 或 Generate Bitstream"
