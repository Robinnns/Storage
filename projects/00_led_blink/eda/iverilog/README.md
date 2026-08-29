# iverilog 仿真工作流（Icarus Verilog）

本目录存放 **iverilog + vvp** 轻量仿真工作流的脚本与说明，与 Vivado 仿真（`eda/vivado/`）互为补充：

- **iverilog**：日常快速功能验证，秒级编译，适合开发迭代
- **Vivado xsim**：综合后仿真、时序仿真、Xilinx 原语仿真

## 目录结构

| 路径 | 说明 |
|------|------|
| `scripts/run_sim.bat` | 一键编译 + 运行脚本（**入库**） |
| `workspace/` | 仿真中间产物（**不入库**，见根 `.gitignore`） |

## 快速开始

```bash
# 一键编译 + 运行（双击或命令行执行）
eda/iverilog/scripts/run_sim.bat

# 产物
#   workspace/top_tb.vvp   编译字节码
#   workspace/top_tb.vcd   波形文件

# 查看波形（需安装 GTKWave）
gtkwave workspace/top_tb.vcd
```

## 工作原理：两阶段流水线

iverilog 是**两阶段**工具，类似 Java 的 `javac` → `.class` → JVM：

```
                    ┌─────────── 阶段一: iverilog (编译) ───────────┐
 rtl/top.v     ──►  │ 预处理 → 解析 → 细化(elaboration) → 字节码生成 │
 tb/tb_top.v   ──►  │                    │                         │
                    └────────────────────┼─────────────────────────┘
                                         ▼
                              top_tb.vvp (字节码)
                                         │
                    ┌─────────── 阶段二: vvp (运行) ──────────────┐
                    │  加载 .vpi 插件 → 事件队列仿真 → $finish      │
                    └────────────────────┼─────────────────────────┘
                                         ▼
                    终端 $display 输出 + top_tb.vcd (波形)
```

### 阶段一：iverilog —— 编译

| 步骤 | 做什么 |
|------|--------|
| **预处理** | 处理 `` `define ``、`` `include ``、`` `ifdef ``（类似 C 预处理器） |
| **语法解析** | 检查 Verilog 语法，建语法树 |
| **细化** | 例化模块、展开 `generate`/`parameter`、确定线宽、连接端口 |
| **代码生成** | 翻译成 vvp 虚拟机的字节码，输出 `.vvp` |

### 阶段二：vvp —— 运行

1. 加载 `.vvp` 头部声明的 VPI 插件库（`system.vpi` 等，实现 `$display`/`$finish`）
2. 维护**事件队列**：`#10` 翻转时钟、`#100` 结束复位……按时间顺序推进
3. 信号变化触发 `always`/`assign` 等过程执行
4. 碰到 `$finish` 停止，退出

## 中间产物含义

| 产物 | 产生者 | 是什么 | 能否删除 |
|------|--------|--------|---------|
| `.vvp` | iverilog | 仿真字节码（类似 Java `.class`，文本可读） | ✅ 可删，重编译即得 |
| `.vcd` | vvp | 标准波形文件（IEEE 1364，纯文本） | ✅ 可删，重跑即得 |
| `.fst` / `.lxt2` | vvp | 替代波形格式（更小更快，GTKWave 支持） | ✅ |
| `.vpi` | 第三方编译 | VPI 插件库（.dll/.so），装于 iverilog `lib/ivl/` | ❌ 不要删 |
| `a.out` | iverilog | 不指定 `-o` 时的默认输出名 | ✅ 可删 |

### `.vvp` 文件头解读

```vvp
#! /c/Source/iverilog-install/bin/vvp   ← shebang: 由 vvp 解释执行
:ivl_version "12.0 (devel)" ...         ← 编译器版本
:vpi_time_precision - 12                ← 时间精度 1ps（来自 timescale 1ns/1ps）
:vpi_module "...\system.vpi"            ← 运行时加载的插件库
S_... .scope module, "tb_top" ...       ← 模块层次
v... .var "clk_50m", 0 0;               ← 信号声明
L_... .functor NOT 1, ...               ← 逻辑门（led2 = ~cnt[25]）
```

### `.vcd` 结构

```vcd
$timescale 1ps $end                     ← 头部: 时间刻度
$scope module tb_top $end
$var wire 1 ! led2 $end                 ← 每个信号分配单字符 ID (! → led2)
...
#10000                                  ← 正文: 时间点 (10000ps = 10ns, 时钟翻转点)
0!                                      ← 值变化: led2 变 0
```

## 命令行旗标速查

```bash
iverilog -g2012            # 启用 SystemVerilog 语法
        -s tb_top          # 指定顶层模块（多文件时必须，否则默认取第一个模块）
        -o out.vvp         # 指定输出（不给就是 a.out）
        -DDUMP_VCD         # 定义宏（配合 tb 的 ifdef 启用波形导出）
        -I <dir>           # 头文件搜索路径
        -y <libdir>        # 库文件搜索路径
        -E                 # 只做预处理，输出展开后的源码
        -Wall              # 打开警告
vvp out.vvp                # 运行仿真
vvp -l log.txt out.vvp     # 日志写入文件
```

## 与 Vivado xsim 对比

| | iverilog + vvp | Vivado xsim |
|---|---|---|
| 定位 | 轻量开源，秒级快速验证 | 与综合/实现同生态 |
| 架构 | 编译为 vvp 字节码 → 虚拟机执行 | 编译为 C++ → 链接成可执行仿真器 |
| 中间产物 | `.vvp` | 编译出的 C++ 源码 + 可执行文件（`.sim/` 下） |
| 波形 | `$dumpfile` 导出 `.vcd`（标准文本） | 默认 `.wdb`（专有格式） |
| 适用场景 | 纯 RTL 功能仿真 | 综合后/时序仿真、Xilinx 原语仿真 |

## 注意

- 本脚本内容为纯 ASCII：Windows cmd 解析批处理时使用代码页而非 UTF-8，中文注释会导致脚本报错
- `workspace/` 由根 `.gitignore` 的 `**/eda/iverilog/workspace/` 忽略，不入库
- 波形导出在 `tb/tb_top.v` 中通过 `` `ifdef DUMP_VCD `` 条件编译启用，Vivado 仿真不受影响
