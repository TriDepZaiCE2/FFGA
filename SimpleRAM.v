module SimpleRAM (
    input wire clk,
    input wire we,                      // Write Enable
    input wire [5:0] addr,              // 6-bit: 64 ??a ch?
    input wire [15:0] din,              // D? li?u ghi vào
    output reg [15:0] dout              // D? li?u ??c ra
);

    reg [15:0] mem [0:63];              // 64 dòng 16-bit

    // Load d? li?u t? file hex
    initial begin
        $readmemh("program.hex", mem);  // ho?c dùng $readmemb cho nh? phân
    end

    always @(posedge clk) begin
        if (we)
            mem[addr] <= din;
        dout <= mem[addr];              // ??c ??ng b?
    end
endmodule

