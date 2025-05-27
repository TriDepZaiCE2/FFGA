module ProgramCounter (
    input wire clk,
    input wire reset_n,
    input wire pc_enable,
    input wire pc_load,
    input wire [15:0] pc_in,
    output reg [15:0] pc_out
);

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            pc_out <= 16'd0;
        else if (pc_enable) begin
            if (pc_load)
                pc_out <= pc_in;
            else
                pc_out <= pc_out + 16'd1;
        end
    end

endmodule