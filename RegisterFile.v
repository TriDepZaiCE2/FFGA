module RegisterFile (
    input wire clk,
    input wire we,
    input wire [2:0] raddr1,
    input wire [2:0] raddr2,
    input wire [2:0] waddr,
    input wire [15:0] wdata,
    input wire [2:0] reg_select,
    output wire [15:0] rdata1,
    output wire [15:0] rdata2,
    output wire [15:0] reg_data_selected
);
    reg [15:0] regs [7:0];

    always @(posedge clk) begin
        if (we && waddr != 3'b000)
            regs[waddr] <= wdata;
    end

    assign rdata1 = (raddr1 == 3'b000) ? 16'd0 : regs[raddr1];
    assign rdata2 = (raddr2 == 3'b000) ? 16'd0 : regs[raddr2];
    assign reg_data_selected = (reg_select == 3'b000) ? 16'd0 : regs[reg_select];

endmodule
