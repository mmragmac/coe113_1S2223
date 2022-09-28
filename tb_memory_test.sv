`timescale 1ns / 1ps

`define ADDR_WIDTH   32
`define WORD_WIDTH   32
`define NUM_CONTENTS 20

module tb_risc;

    // For instruction mem
    logic [`ADDR_WIDTH-1:0] imem_addr;
    wire  [`WORD_WIDTH-1:0] imem_data;
    
    // For data mem
    logic [`ADDR_WIDTH-1:0] dmem_addr;
    logic [`WORD_WIDTH-1:0] dmem_data_in;
    logic                   dmem_wr_en;
    logic                   dmem_mem_read;
    wire  [`WORD_WIDTH-1:0] dmem_data_out;
    
    // Some sim variables
    integer i;

    imem instruction_memory(
        .imem_addr(imem_addr),
        .imem_data(imem_data)
    );
    
    dmem data_memory(
        .dmem_addr      (dmem_addr      ),
        .dmem_data_in   (dmem_data_in   ),
        .dmem_wr_en     (dmem_wr_en     ),
        .dmem_mem_read  (dmem_mem_read  ),
        .dmem_data_out  (dmem_data_out  )
    );

    initial begin
    

    end

endmodule