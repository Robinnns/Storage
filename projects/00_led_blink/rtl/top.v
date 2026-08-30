// ============================================================
// A7-LITE 阶段0 工程 — top module
// 功能: ① 26-bit 计数器点灯 (LED1/LED2 交替闪烁)
//       ② UART 循环发送 "Hello World!\n" (115200, 8-N-1)
//
// 引脚 (已对照 A7-LITE 厂家官方 xdc 核对):
//   CLK_50M : J19  (50MHz 有源晶振)
//   LED1    : M18
//   LED2    : N18
//   RESET   : L18  (板载专用复位, 低有效)
//   UART_TX : V2   (FPGA 发送 → CH340 → PC 串口)
// ============================================================

module top #(
    // 发送周期 (每 SEND_PERIOD_CNT 个时钟发一次 "Hello World!")
    // 默认 500ms (50M × 0.5 = 25M), 仿真时 tb 覆盖此参数缩短
    parameter SEND_PERIOD_CNT = 26'd24_999_999
)(
    input  wire clk_50m,   // 50MHz 系统时钟
    input  wire rst_n,     // 板载复位 RESET (L18, 低有效)
    output wire led1,      // 用户 LED1
    output wire led2,      // 用户 LED2
    output wire uart_tx    // UART 发送 (V2)
);

    // ────────── 点灯: 26-bit 计数器 ──────────
    reg [25:0] cnt;
    always @(posedge clk_50m) begin
        if (!rst_n) cnt <= 26'd0;
        else        cnt <= cnt + 1'b1;
    end
    assign led1 = cnt[25];
    assign led2 = ~cnt[25];

    // ────────── UART 发送 ──────────
    reg        tx_start;   // 发送使能 (脉冲)
    reg  [7:0] tx_data;    // 待发字符
    wire       tx_busy;    // 忙标志

    uart_tx #(.CLK_FREQ(50_000_000), .BAUD(115200)) u_uart (
        .clk      (clk_50m),
        .rst_n    (rst_n),
        .tx_start (tx_start),
        .tx_data  (tx_data),
        .tx       (uart_tx),
        .tx_busy  (tx_busy)
    );

    // 发送控制: 空闲计时 → 逐字符发送 → 回到空闲
    reg [3:0]  msg_idx;     // 当前字符索引 (0..12)
    reg        sending;     // 1 = 正在逐字符发送
    reg [25:0] period_cnt;  // 发送周期计时

    always @(posedge clk_50m) begin
        if (!rst_n) begin
            tx_start   <= 1'b0;
            msg_idx    <= 4'd0;
            sending    <= 1'b0;
            period_cnt <= 26'd0;
        end
        else begin
            tx_start <= 1'b0;   // 默认无发送脉冲

            if (!sending) begin
                // 空闲: 计时到 → 开始发送一轮
                if (period_cnt == SEND_PERIOD_CNT) begin
                    period_cnt <= 26'd0;
                    sending    <= 1'b1;
                    msg_idx    <= 4'd0;
                end
                else begin
                    period_cnt <= period_cnt + 1'b1;
                end
            end
            else begin
                // 发送中: 等 tx_busy 回落 且 tx_start 脉冲已清除, 再发下一个
                // ⚠️ 不能只用 !tx_busy: uart_tx 启动和 tx_busy 更新差一拍,
                //    会在空隙里重复触发导致跳字符 (见 tb 仿真修复记录)
                if (!tx_busy && !tx_start) begin
                    tx_data <= get_msg_char(msg_idx);
                    tx_start <= 1'b1;
                    if (msg_idx == 4'd12) begin   // "Hello World!\n" = 13 字符
                        sending <= 1'b0;
                    end
                    else begin
                        msg_idx <= msg_idx + 1'b1;
                    end
                end
            end
        end
    end

    // 消息表: "Hello World!\n"
    function [7:0] get_msg_char;
        input [3:0] i;
        case (i)
            4'd0:  get_msg_char = "H";
            4'd1:  get_msg_char = "e";
            4'd2:  get_msg_char = "l";
            4'd3:  get_msg_char = "l";
            4'd4:  get_msg_char = "o";
            4'd5:  get_msg_char = " ";
            4'd6:  get_msg_char = "W";
            4'd7:  get_msg_char = "o";
            4'd8:  get_msg_char = "r";
            4'd9:  get_msg_char = "l";
            4'd10: get_msg_char = "d";
            4'd11: get_msg_char = "!";
            4'd12: get_msg_char = "\n";   // 换行
            default: get_msg_char = 8'h00;
        endcase
    endfunction

endmodule
