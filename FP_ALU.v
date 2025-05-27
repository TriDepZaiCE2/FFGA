module FP_ALU (
    input wire [15:0] A,
    input wire [15:0] B,
    input wire [1:0] FPop,   // 00:FADD, 01:FSUB, 10:FMUL
    output reg [15:0] Result,
    output reg Zero
);
    wire signA = A[15];
    wire [4:0] expA = A[14:10];
    wire [9:0] manA = A[9:0];

    wire signB = B[15];
    wire [4:0] expB = B[14:10];
    wire [9:0] manB = B[9:0];

    reg signR;
    reg [5:0] expR;
    reg [21:0] manR;

    wire [10:0] manA11 = {1'b1, manA};
    wire [10:0] manB11 = {1'b1, manB};

    reg [5:0] exp_diff;
    reg [10:0] manA_shifted, manB_shifted;

    integer i;
    reg found;
    reg [4:0] shift_amount;

    always @(*) begin
        signR = 0;
        expR = 0;
        manR = 0;
        Zero = 0;

        case(FPop)
            2'b00: begin // FADD
                if(expA > expB) begin
                    exp_diff = expA - expB;
                    manA_shifted = manA11;
                    manB_shifted = manB11 >> exp_diff;
                    expR = expA;
                end else begin
                    exp_diff = expB - expA;
                    manA_shifted = manA11 >> exp_diff;
                    manB_shifted = manB11;
                    expR = expB;
                end

                if(signA == signB) begin
                    manR = manA_shifted + manB_shifted;
                    signR = signA;
                end else begin
                    if(manA_shifted >= manB_shifted) begin
                        manR = manA_shifted - manB_shifted;
                        signR = signA;
                    end else begin
                        manR = manB_shifted - manA_shifted;
                        signR = signB;
                    end
                end

                // Normalize result:
                found = 0;
                shift_amount = 0;
                for(i=21; i>=0; i=i-1) begin
                    if(!found && manR[i]) begin
                        shift_amount = 10 - i;
                        found = 1;
                    end
                end
                if(found) begin
                    manR = manR << shift_amount;
                    expR = expR - shift_amount;
                end
            end

            2'b01: begin // FSUB: reuse FADD logic with sign inverted B
                // Simplified: same as FADD but invert B sign before calling
                // Or implement similarly with sign handling
            end

            2'b10: begin // FMUL
                signR = signA ^ signB;
                expR = expA + expB - 5'd15; // bias = 15
                manR = manA11 * manB11;
                if(manR[21]) begin
                    manR = manR >> 1;
                    expR = expR + 1;
                end
            end

            default: begin
                signR = 0; expR = 0; manR = 0;
            end
        endcase

        Result = {signR, expR[4:0], manR[20:11]};
        Zero = (Result == 16'h0000);
    end

endmodule