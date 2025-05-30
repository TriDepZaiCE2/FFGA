module ProgramCounter (
    input wire clk,
    input wire rst,
    input wire load,             // Cho phép n?p ??a ch? m?i
    input wire inc,              // Cho phép t?ng PC
    input wire [15:0] pc_in,     // ??a ch? m?i ?? n?p
    output reg [15:0] pc_out     // ??a ch? hi?n t?i
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            pc_out <= 16'd0;
        else if (load)
            pc_out <= pc_in;
        else if (inc)
            pc_out <= pc_out + 1;
    end
endmodule
