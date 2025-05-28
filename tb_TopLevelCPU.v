`timescale 1ns/1ps

module tb_TopLevelCPU;

    reg reset_n;
    reg step_clk;      // Tương ứng KEY[1] - clock bước
    reg run_clk;       // Tương ứng KEY[2] - clock chạy liên tục
    reg [2:0] reg_select;  // Tương ứng SW[2:0]

    wire clk;          // Clock chính cho CPU
    wire [15:0] PC_out;
    wire [15:0] reg_out;
    wire zero_flag;
    wire [2:0] CU_state;
    wire [15:0] IR_out;

    // Clock nội bộ, chọn dùng run_clk hoặc step_clk làm clock CPU
    // Ở đây giả sử thiết kế có logic chọn clock từ hai tín hiệu này,
    // nếu không có, bạn có thể dùng run_clk hoặc step_clk trực tiếp làm clk.

    // Đơn giản: chọn run_clk nếu active, ngược lại step_clk
    reg clk_sel;
    assign clk = clk_sel ? run_clk : step_clk;

    initial begin
        // Khởi tạo tín hiệu
        reset_n = 0;
        step_clk = 0;
        run_clk = 0;
        reg_select = 3'b000;
        clk_sel = 0;  // ban đầu dùng step_clk

        #100;
        reset_n = 1;  // reset hết cpu

        // Bắt đầu mô phỏng, dùng step_clk để chạy từng bước:

        // Nhấn step clock 5 lần (tạo xung cho step_clk)
        repeat (5) begin
            #20 step_clk = 1;
            #20 step_clk = 0;
        end

        // Chuyển sang chạy run_clk liên tục
        clk_sel = 1;
        run_clk = 0;

        // Tạo xung clock liên tục cho run_clk trong 200 chu kỳ
        repeat (200) begin
            #10 run_clk = ~run_clk;
        end

        // Thay đổi reg_select để quan sát các thanh ghi khác
        reg_select = 3'b001; #200;
        reg_select = 3'b010; #200;
        reg_select = 3'b011; #200;

        $stop;  // Kết thúc mô phỏng
    end

    // Instance CPU
    TopLevelCPU cpu (
        .clk(clk),
        .reset_n(reset_n),
        .reg_select(reg_select),
        .PC_out(PC_out),
        .reg_out(reg_out),
        .zero_flag(zero_flag),
        .CU_state(CU_state),
        .IR_out(IR_out)
    );

endmodule