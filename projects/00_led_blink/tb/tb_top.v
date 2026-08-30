// ============================================================
// 阶段0 工程 — 仿真 testbench
// 验证: ① LED 点灯 ② UART 循环发送 "Hello World!\n"
// 方法: 在 tb 里放一个简易 UART 接收器, 把收到的字节打印出来
//
// 用法:
//   Vivado:  Add Sources → Add Simulation Sources 添加本文件
//   Icarus:  eda/iverilog/scripts/run_sim.bat (Windows)
//            或 iverilog -g2012 -DDUMP_VCD -o tb.vvp -s tb_top rtl/top.v rtl/uart_tx.v tb/tb_top.v
// ============================================================

`timescale 1ns / 1ps

module tb_top;

    // 115200 波特率: 一位 = 1/115200 s = 8680 ns
    localparam BIT_NS = 8680;

    // 信号
    reg  clk_50m;
    reg  rst_n;
    wire led1;
    wire led2;
    wire uart_tx;

    // 例化被测模块 (缩短发送周期, 仿真才能观察到完整 "Hello World!")
    top #(
        .SEND_PERIOD_CNT (26'd4999)     // 仿真: 每 100us 发一轮 (硬件默认 500ms)
    ) dut (
        .clk_50m (clk_50m),
        .rst_n   (rst_n),
        .led1    (led1),
        .led2    (led2),
        .uart_tx (uart_tx)
    );

    // VCD 波形导出 (仅 Icarus 仿真启用, Vivado xsim 不受影响)
`ifdef DUMP_VCD
    initial begin
        $dumpfile("top_tb.vcd");
        $dumpvars(0, tb_top);
    end
`endif

    // 50MHz 时钟生成 (周期 20ns)
    always #10 clk_50m = ~clk_50m;

    // ────────── 简易 UART 接收器 (验证发送是否正确) ──────────
    integer b;
    reg  [7:0] rx_byte;
    integer byte_cnt = 0;

    // 检测到起始位下降沿 → 1.5 bit 后采样 d0 中点 → 每 bit 采样一个数据位
    always @(negedge uart_tx) begin
        #(BIT_NS * 3 / 2);              // 1.5 bit → 跳到 d0 中点
        for (b = 0; b < 8; b = b + 1) begin
            rx_byte[b] = uart_tx;       // 中点采样, 抗干扰
            #(BIT_NS);
        end
        byte_cnt = byte_cnt + 1;
        $display("t=%0t [UART] 字节#%0d: 0x%02x '%c'", $time, byte_cnt, rx_byte, rx_byte);
    end

    // ────────── 激励 ──────────
    initial begin
        clk_50m = 0;
        rst_n   = 0;

        // 复位 100ns
        #100;
        rst_n = 1;

        // 观察 ~2ms: 能收到约 2 轮 "Hello World!"
        #2_000_000;
        $display("=== 仿真结束, 共收到 %0d 字节 ===", byte_cnt);
        $finish;
    end

    // 观察 LED 状态 (仅作参考)
    initial begin : led_monitor
        integer i;
        for (i = 0; i < 10; i = i + 1) begin
            #100_000;
            $display("t=%0t LED: led1=%b led2=%b", $time, led1, led2);
        end
    end

endmodule
