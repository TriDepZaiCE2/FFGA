module ClockDivider #(parameter DIV = 25000000)( // Chia 50MHz ? 1Hz
    input wire clk_in,
    input wire rst,
    output reg clk_out
);
    reg [31:0] counter = 0;

    always @(posedge clk_in or posedge rst) begin
        if (rst) begin
            counter <= 0;
            clk_out <= 0;
        end else if (counter >= DIV) begin
            counter <= 0;
            clk_out <= ~clk_out;
        end else begin
            counter <= counter + 1;
        end
    end
endmodule
