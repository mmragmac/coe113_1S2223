`timescale 1ns / 1ps

module risc_pc#(
    parameter DATA_WIDTH = 32
)(
    input   logic                  clk,
    input   logic                  nrst,
    input   logic                  pc_src = 0,
    input   logic [DATA_WIDTH-1:0] addr_offset,
    output  logic [DATA_WIDTH-1:0] addr_out
);
    
    always_ff@(posedge clk or negedge nrst) begin
        if(!nrst) begin
            addr_out <= 32'b0;
        end
        else begin
            if(pc_src == 1) begin
                //addr_out <= addr_offset;
                addr_out <= addr_out + (addr_offset << 1);
            end
            else begin
                addr_out <= addr_out + 32'd4;
            end
        end
    end
        
endmodule
