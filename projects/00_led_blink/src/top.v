// ============================================================
// A7-LITE 点灯工程 — top module
// 平台: Microphase A7-LITE (XC7A35T)
// 功能: 26-bit 计数器分频 50MHz 时钟 → LED1/LED2 交替闪烁
// ============================================================
//
// 原理:
//   50MHz 时钟下, 计数器每个周期 +1
//   cnt[25] 每 2^26 个时钟翻转一次 = 50MHz / 67,108,864 ≈ 0.745 Hz
//   → LED1 每 ~1.34s 亮灭一次, LED2 与之互补
//
// 引脚 (已对照 A7-LITE 厂家官方 xdc 核对):
//   CLK_50M : J19  (50MHz 有源晶振)
//   LED1    : M18
//   LED2    : N18
//   RESET   : L18  (板载专用复位, 低有效)

module top (
    input  wire clk_50m,   // 50MHz 系统时钟
    input  wire rst_n,     // 板载复位 RESET (L18, 低有效)
    output wire led1,      // 用户 LED1
    output wire led2       // 用户 LED2
);

    // 同步复位计数器
    reg [25:0] cnt;

    always @(posedge clk_50m) begin
        if (!rst_n)
            cnt <= 26'd0;
        else
            cnt <= cnt + 1'b1;
    end

    // 取计数器最高位驱动 LED
    assign led1 = cnt[25];
    assign led2 = ~cnt[25];

endmodule
