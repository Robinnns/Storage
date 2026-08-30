// ============================================================
// UART 发送模块 (uart_tx)
// 协议: 8-N-1 (1 起始位 + 8 数据位 + 1 停止位, 无校验)
//
// 原理: 异步串行——没有时钟线, 靠约定的波特率逐位发送.
//   空闲: tx = 1 (高电平)
//   一帧: [start=0] [d0..d7] [stop=1], 数据 LSB first
//
// 时序 (以 115200 为例):
//   每位 = 1/115200 ≈ 8.68us = 50MHz 下的 434 个时钟
// ============================================================

module uart_tx #(
    parameter CLK_FREQ = 50_000_000,  // 系统时钟频率 (Hz)
    parameter BAUD     = 115200       // 波特率 (bps)
)(
    input  wire       clk,       // 系统时钟
    input  wire       rst_n,     // 复位 (低有效)
    input  wire       tx_start,  // 发送使能: 高电平一个时钟周期触发一帧
    input  wire [7:0] tx_data,   // 要发送的字节
    output reg        tx,        // 串行输出 (空闲为高)
    output wire       tx_busy    // 忙标志: 1=发送中, 0=空闲
);

    // 每个 bit 持续多少个时钟周期: 50M/115200 = 434 → 减 1 做循环计数
    localparam BIT_CNT_MAX = CLK_FREQ / BAUD - 1;

    reg [15:0] cnt;       // bit 周期计数器
    reg [3:0]  bit_cnt;   // 已经发出的位数 (0=空闲, 1..10=发送中)
    reg [9:0]  frame;     // 发送帧: {stop, d7..d0, start}

    assign tx_busy = (bit_cnt != 4'd0);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tx      <= 1'b1;    // 空闲为高
            bit_cnt <= 4'd0;
            cnt     <= 16'd0;
        end
        else if (tx_start && bit_cnt == 4'd0) begin
            // 启动发送: 拼好一帧 + 打起始位(低)
            frame   <= {1'b1, tx_data, 1'b0};   // {stop, data[7:0], start}
            bit_cnt <= 4'd1;                    // 起始位已发出
            tx      <= 1'b0;                    // 起始位 = 低
            cnt     <= 16'd0;
        end
        else if (bit_cnt != 4'd0) begin
            // 发送中: 每 BIT_CNT_MAX 个时钟推进一位
            if (cnt == BIT_CNT_MAX) begin
                cnt <= 16'd0;
                if (bit_cnt == 4'd10) begin
                    bit_cnt <= 4'd0;    // 10 bit 已发完 → 回空闲
                    tx      <= 1'b1;
                end
                else begin
                    tx      <= frame[bit_cnt];   // bit_cnt=1→d0, ..., 9→stop
                    bit_cnt <= bit_cnt + 1'b1;
                end
            end
            else begin
                cnt <= cnt + 1'b1;
            end
        end
    end

endmodule
