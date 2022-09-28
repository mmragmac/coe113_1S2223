`timescale 1ns / 1ps

module risc_imm#(
    parameter DATA_WIDTH = 32
)(
    input   logic [1:0]            imm_src,
    input   logic [DATA_WIDTH-1:0] imm_input,
    output  logic [DATA_WIDTH-1:0] imm_output
);

    always_comb begin
        case(imm_src)
            2'b00: imm_output <= {{20{imm_input[31]}}, imm_input[31:20]}; //I
            2'b01: imm_output <= {{20{imm_input[31]}}, imm_input[31:25], imm_input[11:7]}; //S
            2'b10: imm_output <= {{20{imm_input[31]}}, imm_input[7], imm_input[30:25], imm_input[11:8], 1'b0}; //B
            2'b11: imm_output <= {{12{imm_input[31]}}, imm_input[19:12], imm_input[20], imm_input[30:21], 1'b0}; //J
        endcase
    end

endmodule
