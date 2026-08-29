# 板卡 BSP 层（fpga/）

每个用到的板卡一个子目录，放与该板卡绑定的一切，与设计源码（`src/`）解耦：

- `<板卡名>.xdc` — 板级约束（引脚分配 + 时钟约束），Vivado 直接引用
- `pinmap.md` — 自整理的引脚速查表
- `README.md` — 板卡资料链接 + 引脚核对记录

**参考实现：** `../00_led_blink/fpga/a7_lite/`

新建工程时，把当前目标板卡的 BSP 目录复制/创建进来，再在
`eda/vivado/scripts/create_project.tcl` 的 add_files 里指向它。
