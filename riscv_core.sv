`timescale 1ns / 1ps

module riscv_core#(
    parameter WORD_WIDTH        = 32,
    parameter REG_ADDR_WIDTH    = 5
)(
    // Clocks and resets
    input   logic clk,
    input   logic nrst,
    
    // Signals for the instruction memory
    input   logic [WORD_WIDTH-1:0] imem_data,
    output  logic [WORD_WIDTH-1:0] imem_addr,
    
    // Signals for the data memory
    output  logic [WORD_WIDTH-1:0] dmem_addr,
    output  logic [WORD_WIDTH-1:0] dmem_data_in,
    output  logic                  dmem_wr_en,
    input   logic [WORD_WIDTH-1:0] dmem_data_out,
    
    // Output signals meant for monitoring
    output  logic [6:0]                 opcode,   
    output  logic [2:0]                 funct3, 
    output  logic [6:0]                 funct7, 
    output  logic [WORD_WIDTH-1:0]      imm_ext,
    output  logic [REG_ADDR_WIDTH-1:0]  reg_src1,
    output  logic [REG_ADDR_WIDTH-1:0]  reg_src2,
    output  logic [REG_ADDR_WIDTH-1:0]  reg_dst,
    output  logic [WORD_WIDTH-1:0]      wr_data,
    output  logic [WORD_WIDTH-1:0]      rd_dataA,
    output  logic [WORD_WIDTH-1:0]      rd_dataB,
    output  logic                       wr_en,
    output  logic                       alu_src,
    output  logic                       pc_src,
    output  logic [2:0]                 alu_op,
    output  logic [1:0]                 imm_src,
    output  logic                       mem_write,
    output  logic [1:0]                 mem_to_reg,
    output  logic [WORD_WIDTH-1:0]      alu_out,
    output  logic                       zero
);
    logic   [WORD_WIDTH-1:0]    operandB;

    always_comb begin
        opcode = imem_data[6:0];
        funct3 = imem_data[14:12];
        funct7 = imem_data[31:25];
        reg_src1 = imem_data[19:15];
        reg_src2 = imem_data[24:20];
        reg_dst = imem_data[11:7];
        dmem_wr_en = mem_write;
        dmem_addr = alu_out;
        dmem_data_in = rd_dataB;
    end
    
    risc_pc PC(
        .clk(clk),
        .nrst(nrst),
        .pc_src(pc_src),
        .addr_offset(imm_ext),
        .addr_out(imem_addr)
    );
    
    risc_comb_controller controller(
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .zero(zero),
        .wr_en(wr_en),
        .alu_src(alu_src),
        .alu_op(alu_op),
        .pc_src(pc_src),
        .imm_src(imm_src),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg)
    );
	
	riscv_reg regfile(
	   .clk(clk),
	   .nrst(nrst),
	   .wr_en(wr_en),
	   .wr_addr(reg_dst),
	   .wr_data(wr_data),
	   .rd_addrA(reg_src1),
	   .rd_addrB(reg_src2),
	   .rd_dataA(rd_dataA),
	   .rd_dataB(rd_dataB)
	);
	
	risc_imm imm_gen(
	   .imm_src(imm_src),
	   .imm_input(imem_data),
	   .imm_output(imm_ext)
	);
	
	risc_mux_alu mux_ALU(
	   .rd_dataB(rd_dataB),
	   .imm_ext(imm_ext),
	   .alu_src(alu_src),
	   .operandB(operandB)
	);
	
	risc_alu ALU(
	   .operandA(rd_dataA),
	   .operandB(operandB),
	   .alu_op(alu_op),
	   .alu_out(alu_out),
	   .zero(zero)
	);
	
	risc_mux_result mux_result(
	   .alu_out(alu_out),
	   .dmem_data_out(dmem_data_out),
	   .pc(imem_addr),
	   .mem_to_reg(mem_to_reg),
	   .wr_data(wr_data)
	);
	
endmodule
