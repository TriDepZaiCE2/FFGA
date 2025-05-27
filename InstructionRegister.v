module InstructionRegister (
    input wire clk,
    input wire load_ir,
    input wire [15:0] instr_in,
    output reg [15:0] instr_out
);

    always @(posedge clk) begin
        if (load_ir)
            instr_out <= instr_in;
    end

endmodule