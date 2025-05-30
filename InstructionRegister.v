module InstructionRegister (
    input wire clk,
    input wire rst,
    input wire load,
    input wire [15:0] instr_in,
    output reg [15:0] instr_out
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            instr_out <= 16'd0;
        else if (load)
            instr_out <= instr_in;
    end
endmodule

