module ControlUnit (
    input wire clk,
    input wire reset_n,
    input wire [15:0] IR,
    input wire Zero_flag,
    output reg PC_enable,
    output reg PC_load,
    output reg IR_load,
    output reg RF_we,
    output reg [3:0] ALU_op,
    output reg RAM_read,
    output reg RAM_write,
    output reg [2:0] state_out
);

    reg [2:0] state, next_state;
    wire [3:0] opcode = IR[15:12];

    localparam FETCH1 = 3'd0, FETCH2 = 3'd1, DECODE = 3'd2,
               EXECUTE = 3'd3, WRITEBACK = 3'd4, IDLE = 3'd5;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            state <= FETCH1;
        else
            state <= next_state;
    end

    always @(*) begin
        PC_enable = 0;
        PC_load = 0;
        IR_load = 0;
        RF_we = 0;
        ALU_op = 4'b0000;
        RAM_read = 0;
        RAM_write = 0;
        next_state = state;
        state_out = state;

        case (state)
            FETCH1: begin
                RAM_read = 1;
                PC_enable = 1;
                next_state = FETCH2;
            end
            FETCH2: begin
                IR_load = 1;
                next_state = DECODE;
            end
            DECODE: begin
                next_state = EXECUTE;
            end
            EXECUTE: begin
                case (opcode)
                    4'h2: ALU_op = 4'b0000; // ADD
                    4'h3: ALU_op = 4'b0001; // SUB
                    // Thêm opcode khác tùy thiết kế
                    default: ALU_op = 4'b0000;
                endcase
                next_state = WRITEBACK;
            end
            WRITEBACK: begin
                RF_we = 1;
                next_state = FETCH1;
            end
            default: next_state = FETCH1;
        endcase
    end
endmodule