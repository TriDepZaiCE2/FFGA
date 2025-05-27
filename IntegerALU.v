module IntegerALU (
    input wire [15:0] A,
    input wire [15:0] B,
    input wire [3:0] ALUop,
    output reg [15:0] Result,
    output reg Zero
);

    always @(*) begin
        case (ALUop)
            4'b0000: Result = A + B;          // ADD
            4'b0001: Result = A - B;          // SUB
            4'b0010: Result = A & B;          // AND
            4'b0011: Result = A | B;          // OR
            4'b0100: Result = A ^ B;          // XOR
            4'b0101: Result = (A * B) & 16'hFFFF; // MUL low 16bit
            4'b0110: Result = B << A[3:0];    // SLL
            4'b0111: Result = B >> A[3:0];    // SRL
            4'b1000: Result = $signed(B) >>> A[3:0]; // SRA
            default: Result = 16'd0;
        endcase
        Zero = (Result == 16'd0);
    end

endmodule