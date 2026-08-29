// ============================================================
// 点灯工程 — 仿真 testbench
// 用法: 在 Vivado 中 Add Sources → Add Simulation Sources 添加
//       (或在 Windows 上用 Icarus 仿真: iverilog -o tb top.v tb_top.v)
// ============================================================

`timescale 1ns / 1ps

module tb_top;

    // 信号
    reg  clk_50m;
    reg  rst_n;
    wire led1;
    wire led2;

    // 例化被测模块
    top dut (
        .clk_50m (clk_50m),
        .rst_n   (rst_n),
        .led1    (led1),
        .led2    (led2)
    );

    // 50MHz 时钟生成 (周期 20ns)
    always #10 clk_50m = ~clk_50m;

    // 激励
    initial begin
        clk_50m = 0;
        rst_n   = 0;

        // 复位 100ns
        #100;
        rst_n = 1;

        // 观察 26-bit 计数器的翻转 (完整翻转需 1.34s, 仿真只观察部分)
        // 用 2^25 = 33,554,432 个周期 = 671,088,640 ns ≈ 671ms, 太长
        // 建议: 仿真时临时把 top.v 中计数器改小 (如 8-bit) 加速观察
        // 或直接观察几个周期验证信号正确性
        #1000;
        $display("led1=%b led2=%b (期望互补)", led1, led2);

        #2000;
        $finish;
    end

    // 打印每 200ns 的状态, 便于观察
    initial begin
        integer i;
        for (i = 0; i < 15; i = i + 1) begin
            #200;
            $display("t=%0t  cnt_led1=%b  led2=%b", $time, led1, led2);
        end
    end

endmodule
