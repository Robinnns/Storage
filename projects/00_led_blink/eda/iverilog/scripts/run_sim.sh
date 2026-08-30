#!/bin/bash
# ============================================================
# iverilog simulation script (macOS / Linux)
# Usage: bash eda/iverilog/scripts/run_sim.sh
# Outputs: eda/iverilog/workspace/top_tb.vvp / top_tb.vcd (gitignored)
# View:    surfer eda/iverilog/workspace/top_tb.vcd
#          (or gtkwave if installed)
# ============================================================

set -e   # 出错即停

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
WORK_DIR="$SCRIPT_DIR/../workspace"
RTL_DIR="$SCRIPT_DIR/../../../rtl"
TB_DIR="$SCRIPT_DIR/../../../tb"
TOP="tb_top"

# 确保输出目录存在
mkdir -p "$WORK_DIR"

# ---- 阶段一: iverilog 编译 (VCD 通过 DUMP_VCD 宏启用) ----
iverilog -g2012 -DDUMP_VCD -o "$WORK_DIR/top_tb.vvp" -s "$TOP" "$RTL_DIR"/*.v "$TB_DIR"/*.v

# ---- 阶段二: vvp 运行 (cwd 切到 workspace, VCD 写这里) ----
cd "$WORK_DIR"
vvp top_tb.vvp

echo ""
echo "[OK] 仿真完成"
echo "     波形: $WORK_DIR/$TOP.vcd"
echo "     查看: surfer $WORK_DIR/$TOP.vcd"
