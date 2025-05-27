module RegisterFile (
    input wire clk,
    input wire we,
    input wire [2:0] read_addr1,
    input wire [2:0] read_addr2,
    input wire [2:0] write_addr,
    input wire [15:0] write_data,
    input wire [2:0] reg_select,
    output reg [15:0] read_data1,
    output reg [15:0] read_data2,
    output reg [15:0] reg_data_selected
);

    reg [15:0] regs [7:0];

    always @(*) begin
        read_data1 = (read_addr1 == 3'b000) ? 16'd0 : regs[read_addr1];
        read_data2 = (read_addr2 == 3'b000) ? 16'd0 : regs[read_addr2];
        reg_data_selected = (reg_select == 3'b000) ? 16'd0 : regs[reg_select];
    end

    always @(posedge clk) begin
        if (we && write_addr != 3'b000)
            regs[write_addr] <= write_data;
    end

endmodule