`timescale 1ns / 1ps

module risc_mux_alu#(
    parameter DATA_WIDTH = 32
)(
    input   logic [DATA_WIDTH-1:0]  rd_dataB,
    input   logic [DATA_WIDTH-1:0]  imm_ext,
    input   logic                   alu_src,
    output  logic [DATA_WIDTH-1:0]  operandB
     
);

always_comb begin
    case(alu_src)
        1'b0: operandB <= rd_dataB;
        1'b1: operandB <= imm_ext;
    endcase
end

endmodule

module risc_mux_result#(
    parameter DATA_WIDTH = 32
)(
    input   logic [DATA_WIDTH-1:0] alu_out,
    input   logic [DATA_WIDTH-1:0] dmem_data_out,
    input   logic [DATA_WIDTH-1:0] pc,
    input   logic [1:0]            mem_to_reg,
    output  logic [DATA_WIDTH-1:0] wr_data
     
);

always_comb begin
    case(mem_to_reg)
        2'b00: wr_data <= alu_out;
        2'b01: wr_data <= dmem_data_out;
        2'b10: wr_data <= pc;
    endcase
end

endmodule