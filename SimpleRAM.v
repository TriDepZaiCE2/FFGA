module SimpleRAM (
    input wire clk,
    input wire we,
    input wire [5:0] addr,
    input wire [15:0] data_in,
    output reg [15:0] data_out
);

    reg [15:0] mem [63:0];

    initial begin
        $readmemh("program.hex", mem);
    end

    always @(posedge clk) begin
        if (we)
            mem[addr] <= data_in;
        data_out <= mem[addr];
    end

endmodule