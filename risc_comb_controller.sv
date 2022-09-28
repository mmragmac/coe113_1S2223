`timescale 1ns / 1ps

module risc_comb_controller#(
    parameter add = 5'd0,
    parameter sub = 5'd1,
    parameter andop = 5'd2,
    parameter orop = 5'd3,
    parameter sll = 5'd4,
    parameter srl = 5'd5,
    parameter addi = 5'd6,
    parameter andi = 5'd7,
    parameter ori = 5'd8,
    parameter slli = 5'd9,
    parameter srli = 5'd10,
    parameter lw = 5'd11,
    parameter sw = 5'd12,
    parameter beq = 5'd13,
    parameter bne = 5'd14,
    parameter jal = 5'd15
)(
    input   logic [6:0] opcode,  
    input   logic [2:0] funct3,
    input   logic [6:0] funct7,
    input   logic       zero,
    output  logic       wr_en,
    output  logic       alu_src,
    output  logic [2:0] alu_op,
    output  logic       pc_src,
    output  logic [1:0] imm_src,
    output  logic       mem_write,
    output  logic [1:0] mem_to_reg     
    );
    
    logic [4:0] operation;
    
    always_comb begin
        case(opcode)
            7'b0110011:
                case(funct3)
                    3'b000:
                        if(funct7==7'b0100000)
                            operation = sub;
                        else if(funct7==7'b0000000)
                            operation = add;
                    3'b111:
                        operation = andop;
                    3'b110:
                        operation = orop;
                    3'b001:
                        operation = sll;
                    3'b101:
                        operation = srl;
                 endcase
            7'b0010011:
                case(funct3)
                    3'b000:
                        operation = addi;
                    3'b111:
                        operation = andi;
                    3'b110:
                        operation = ori;
                    3'b001:
                        operation = slli;
                    3'b101:
                        operation = srli;
                endcase
            7'b0000011:
                operation = lw;
            7'b0100011:
                operation = sw;
            7'b1100011:
                case(funct3)
                    3'b000:
                        operation = beq;
                    3'b001:
                        operation = bne;
                endcase
            7'b1101111:
                operation = jal;
        endcase
    end

    always_comb begin
        case(operation)
            add: begin
                wr_en = 1'b1;
                alu_src = 1'b0;
                alu_op = 3'b000;
                pc_src = 1'b0;
                imm_src = 2'b00; // technically don't care
                mem_write = 1'b0;
                mem_to_reg = 2'b00;
            end
            sub: begin
                wr_en = 1'b1;
                alu_src = 1'b0;
                alu_op = 3'b001;
                pc_src = 1'b0;
                imm_src = 2'b00; // technically don't care
                mem_write = 1'b0;
                mem_to_reg = 2'b00;
            end
            andop: begin
                wr_en = 1'b1;
                alu_src = 1'b0;
                alu_op = 3'b010;
                pc_src = 1'b0;
                imm_src = 2'b00; // technically don't care
                mem_write = 1'b0;
                mem_to_reg = 2'b00;
            end
            orop: begin
                wr_en = 1'b1;
                alu_src = 1'b0;
                alu_op = 3'b011;
                pc_src = 1'b0;
                imm_src = 2'b00; // technically don't care
                mem_write = 1'b0;
                mem_to_reg = 2'b00;
            end
            sll: begin
                wr_en = 1'b1;
                alu_src = 1'b0;
                alu_op = 3'b100;
                pc_src = 1'b0;
                imm_src = 2'b00; // technically don't care
                mem_write = 1'b0;
                mem_to_reg = 2'b00;
            end
            srl: begin
                wr_en = 1'b1;
                alu_src = 1'b0;
                alu_op = 3'b101;
                pc_src = 1'b0;
                imm_src = 2'b00; // technically don't care
                mem_write = 1'b0;
                mem_to_reg = 2'b00;
            end
            addi: begin
                wr_en = 1'b1;
                alu_src = 1'b1;
                alu_op = 3'b000;
                pc_src = 1'b0;
                imm_src = 2'b00;
                mem_write = 1'b0;
                mem_to_reg = 2'b00;
            end
            andi: begin
                wr_en = 1'b1;
                alu_src = 1'b1;
                alu_op = 3'b010;
                pc_src = 1'b0;
                imm_src = 2'b00;
                mem_write = 1'b0;
                mem_to_reg = 2'b00;
            end
            ori: begin
                wr_en = 1'b1;
                alu_src = 1'b1;
                alu_op = 3'b011;
                pc_src = 1'b0;
                imm_src = 2'b00;
                mem_write = 1'b0;
                mem_to_reg = 2'b00;
            end
            slli: begin
                wr_en = 1'b1;
                alu_src = 1'b1;
                alu_op = 3'b100;
                pc_src = 1'b0;
                imm_src = 2'b00;
                mem_write = 1'b0;
                mem_to_reg = 2'b00;
            end
            srli: begin
                wr_en = 1'b1;
                alu_src = 1'b1;
                alu_op = 3'b101;
                pc_src = 1'b0;
                imm_src = 2'b00;
                mem_write = 1'b0;
                mem_to_reg = 2'b00;
            end
            lw: begin
                wr_en = 1'b1;
                alu_src = 1'b1;
                alu_op = 3'b000;
                pc_src = 1'b0;
                pc_src = 1'b0;
                imm_src = 2'b00;
                mem_write = 1'b0;
                mem_to_reg = 2'b01;
            end
            sw: begin
                wr_en = 1'b0;
                alu_src = 1'b1;
                alu_op = 3'b000;
                pc_src = 1'b0;
                imm_src = 2'b01;
                mem_write = 1'b1;
                mem_to_reg = 2'b00; // technically don't care
            end
            beq: begin
                wr_en = 1'b0;
                alu_src = 1'b0;
                alu_op = 3'b001;
                imm_src = 2'b10;
                mem_write = 1'b0;
                mem_to_reg = 2'b00;
                if (zero == 1) begin
                    pc_src = 1'b1;
                end
                else begin
                    pc_src = 1'b0;
                end
            end
            bne: begin
                wr_en = 1'b0;
                alu_src = 1'b0;
                alu_op = 3'b001;
                imm_src = 2'b10;
                mem_write = 1'b0;
                mem_to_reg = 2'b00;
                if (zero == 1) begin
                    pc_src = 1'b0;
                end
                else begin
                    pc_src = 1'b1;
                end
            end
            jal: begin
                wr_en = 1'b1;
                alu_src = 1'b0; // technically don't care
                alu_op = 3'b000;  // technically don't care
                pc_src = 1'b1;
                imm_src = 2'b11;
                mem_write = 1'b0;
                mem_to_reg = 2'b10; 
            end
        endcase
    end
endmodule
