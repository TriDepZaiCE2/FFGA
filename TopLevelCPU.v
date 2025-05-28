module TopLevelCPU (
    input wire clk,
    input wire reset_n,
    input wire [2:0] reg_select,
    output wire [15:0] PC_out,
    output wire [15:0] reg_out,
    output wire zero_flag,
    output wire [2:0] CU_state,
    output wire [15:0] IR_out
);

    wire [15:0] ram_data_out;
    wire ram_we, ram_re;
    wire [5:0] ram_addr;

    wire [15:0] IR;
    wire [15:0] PC;
    wire ALU_zero;
    wire [3:0] ALU_op;

    wire RF_we;
    wire [2:0] Rd, Rs, Rt;
    wire [15:0] RF_write_data, RF_read_data1, RF_read_data2;
    wire [15:0] reg_data_selected;

    wire pc_enable_sig, pc_load_sig, ir_load_sig;

    assign IR_out = IR;
    assign PC_out = PC;
    assign zero_flag = ALU_zero;

    assign Rd = IR[11:9];
    assign Rs = IR[8:6];
    assign Rt = IR[5:3];

    ProgramCounter pc (
        .clk(clk),
        .reset_n(reset_n),
        .pc_enable(pc_enable_sig),
        .pc_load(pc_load_sig),
        .pc_in(16'd0),
        .pc_out(PC)
    );

    InstructionRegister ir (
        .clk(clk),
        .load_ir(ir_load_sig),
        .instr_in(ram_data_out),
        .instr_out(IR)
    );

    RegisterFile rf (
        .clk(clk),
        .we(RF_we),
        .read_addr1(Rs),
        .read_addr2(Rt),
        .write_addr(Rd),
        .write_data(RF_write_data),
        .reg_select(reg_select),
        .read_data1(RF_read_data1),
        .read_data2(RF_read_data2),
        .reg_data_selected(reg_data_selected)
    );

    IntegerALU alu (
        .A(RF_read_data1),
        .B(RF_read_data2),
        .ALUop(ALU_op),
        .Result(RF_write_data),
        .Zero(ALU_zero)
    );

    ControlUnit cu (
        .clk(clk),
        .reset_n(reset_n),
        .IR(IR),
        .Zero_flag(ALU_zero),
        .PC_enable(pc_enable_sig),
        .PC_load(pc_load_sig),
        .IR_load(ir_load_sig),
        .RF_we(RF_we),
        .ALU_op(ALU_op),
        .RAM_read(ram_re),
        .RAM_write(ram_we),
        .state_out(CU_state)
    );

    SimpleRAM ram (
        .clk(clk),
        .we(ram_we),
        .addr(PC[5:0]),
        .data_in(RF_read_data2),
        .data_out(ram_data_out)
    );

    assign reg_out = reg_data_selected;

endmodule