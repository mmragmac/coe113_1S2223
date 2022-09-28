`timescale 1ns / 1ps

module riscv_reg #(
    parameter ADDR_WIDTH = 5,
    parameter DATA_WIDTH = 32,
    parameter REG_COUNT = 32
)(
    input  logic                  clk,
    input  logic                  nrst,
    input  logic                  wr_en,
    input  logic [ADDR_WIDTH-1:0] wr_addr,
    input  logic [DATA_WIDTH-1:0] wr_data,
    input  logic [ADDR_WIDTH-1:0] rd_addrA,
    input  logic [ADDR_WIDTH-1:0] rd_addrB,
    output logic [DATA_WIDTH-1:0] rd_dataA,
    output logic [DATA_WIDTH-1:0] rd_dataB
);

    logic [DATA_WIDTH-1:0] register [0:REG_COUNT-1];
    integer i;
    
    always_ff@(posedge clk or negedge nrst) begin
        if(!nrst) begin
            for(i=0; i < REG_COUNT; i = i+1)
                register[i] = 32'd0;
//                register[0] <= 32'd31;
//                register[1] <= 32'd30;
//                register[2] <= 32'd29;
//                register[3] <= 32'd28;
//                register[4] <= 32'd27;
//                register[5] <= 32'd26;
//                register[6] <= 32'd25;
//                register[7] <= 32'd24;
//                register[8] <= 32'd23;
//                register[9] <= 32'd22;
//                register[10] <= 32'd21;
//                register[11] <= 32'd20;
//                register[12] <= 32'd19;
//                register[13] <= 32'd18;
//                register[14] <= 32'd17;
//                register[15] <= 32'd16;
//                register[16] <= 32'd15;
//                register[17] <= 32'd14;
//                register[18] <= 32'd13;
//                register[19] <= 32'd12;
//                register[20] <= 32'd11;
//                register[21] <= 32'd10;
//                register[22] <= 32'd9;
//                register[23] <= 32'd8;
//                register[24] <= 32'd7;
//                register[25] <= 32'd6;
//                register[26] <= 32'd5;
//                register[27] <= 32'd4;
//                register[28] <= 32'd3;
//                register[29] <= 32'd2;
//                register[30] <= 32'd1;
//                register[31] <= 32'd0;
        end
        else begin
            if(wr_addr != 0 && wr_en == 1) begin
                register[wr_addr] <= wr_data;
            end
        end
    end
    
    always_comb begin
        if(!nrst) begin
            rd_dataA = 32'd0;
            rd_dataB = 32'd0;
        end
        else begin
            rd_dataA = register[rd_addrA];
            rd_dataB = register[rd_addrB];
        end
    end
    
endmodule
