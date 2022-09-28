`timescale 1ns / 1ps

module risc_alu#(
    parameter DATA_WIDTH = 32
)(
    input   logic [DATA_WIDTH-1:0] operandA,
    input   logic [DATA_WIDTH-1:0] operandB,
    input   logic [2:0]            alu_op,
    output  logic [DATA_WIDTH-1:0] alu_out,
    output  logic                  zero
);

    always_comb begin
        case(alu_op)
            3'b000: alu_out <= operandA + operandB; //ADD
            3'b001: alu_out <= operandA - operandB; //SUB
            3'b010: alu_out <= operandA & operandB; //AND
            3'b011: alu_out <= operandA | operandB; //OR
            3'b100: alu_out <= operandA << operandB; //SLL
            3'b101: alu_out <= operandA >> operandB; //SRL
        endcase
        
//        if(alu_out == 0) begin
//            zero = alu_out;
//        end
//        else begin
//            zero = alu_out;
//        end
    end

    assign zero = (alu_out == 0);
endmodule
