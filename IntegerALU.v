module IntegerALU (
    input wire [15:0] op1,         // toán h?ng 1
    input wire [15:0] op2,         // toán h?ng 2 ho?c immediate
    input wire [3:0] alu_op,       // mã ?i?u khi?n ALU
    output reg [15:0] result,      // k?t qu?
    output wire zero               // c? Zero (k?t qu? = 0)
);

    // mã l?nh ALU
    localparam ADD = 4'b0000,
               SUB = 4'b0001,
               AND_ = 4'b0010,
               OR_  = 4'b0011,
               XOR_ = 4'b0100,
               MUL = 4'b0101,
               SLL = 4'b0110,
               SRL = 4'b0111,
               SRA = 4'b1000;

    always @(*) begin
        case (alu_op)
            ADD: result = op1 + op2;
            SUB: result = op1 - op2;
            AND_: result = op1 & op2;
            OR_:  result = op1 | op2;
            XOR_: result = op1 ^ op2;
            MUL:  result = op1 * op2; // gi? 16 bit th?p
            SLL:  result = op1 << op2[3:0];
            SRL:  result = op1 >> op2[3:0];
            SRA:  result = $signed(op1) >>> op2[3:0];
            default: result = 16'd0;
        endcase
    end

    assign zero = (result == 16'd0);

endmodule
