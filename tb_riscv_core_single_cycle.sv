`timescale 1ns / 1ps

//===========================================
// Testbench for single cycle testing.
// Please take note, DO NOT CHANGE ANYTHING IN HERE!!!
// You can read how the code works.
//===========================================

// Some useful macro definitions
`define ADDR_WIDTH      32
`define WORD_WIDTH      32
`define REG_ADDR_WIDTH  5
`define NUM_CONTENTS    20
`define BYTE_WIDTH      8

// Main testbench module
module tb_riscv_core_single_cycle;

    //===========================================
    // Declaration of wires and drivers
    //===========================================
    
    // Clock and reset drivers
    logic clk, nrst;
    
    // For instruction mem
    wire [`ADDR_WIDTH-1 :0]     imem_addr;
    wire  [`WORD_WIDTH-1:0]     imem_data;
    
    // For data mem
    wire [`ADDR_WIDTH-1 :0]     dmem_addr;
    wire [`WORD_WIDTH-1 :0]     dmem_data_in;
    wire                        dmem_wr_en;
    wire  [`WORD_WIDTH-1:0]     dmem_data_out;
    
    // Wires for monitoring purposes
    // These are connected directl to the riscv core
    wire [6:0]                  opcode;
    wire [2:0]                  funct3; 
    wire [6:0]                  funct7; 
    wire [`WORD_WIDTH-1:0]      imm_ext;
	wire                        wr_en;
    wire [`WORD_WIDTH-1:0]      wr_data;
    wire [`REG_ADDR_WIDTH-1:0]  reg_src1;
    wire [`REG_ADDR_WIDTH-1:0]  reg_src2;
    wire [`REG_ADDR_WIDTH-1:0]  reg_dst;
    wire [`WORD_WIDTH-1:0]      rd_dataA;
    wire [`WORD_WIDTH-1:0]      rd_dataB;
    wire                        alu_src;
    wire                        pc_src;
    wire [2:0]                  alu_op;
    wire [1:0]                  imm_src;
    wire                        mem_write;
    wire [1:0]                  mem_to_reg;
    wire [`WORD_WIDTH-1:0]      alu_out;
    wire                        zero;
    
    //===========================================
    // Declartion of instances.
    // We only need the item memory, the riscv core, and data memory.
    //===========================================
    
    // Instruction memory
    imem instruction_memory(
        .imem_addr      (imem_addr      ),
        .imem_data      (imem_data      )
    );
    
    // RISCV core
    riscv_core RV32I(
        .clk            (clk            ),
        .nrst           (nrst           ),
        .imem_data      (imem_data      ),
        .imem_addr      (imem_addr      ),
        .dmem_addr      (dmem_addr      ),
        .dmem_data_in   (dmem_data_in   ),
        .dmem_wr_en     (dmem_wr_en     ),
        .dmem_data_out  (dmem_data_out  ),
        .opcode         (opcode         ),
        .funct3         (funct3         ),
        .funct7         (funct7         ),
        .imm_ext        (imm_ext        ),
        .wr_data        (wr_data        ),
        .reg_src1       (reg_src1       ),
        .reg_src2       (reg_src2       ),
        .reg_dst        (reg_dst        ),
        .rd_dataA       (rd_dataA       ),
        .rd_dataB       (rd_dataB       ),
        .wr_en          (wr_en          ),
        .alu_src        (alu_src        ),
        .pc_src         (pc_src         ),
        .alu_op         (alu_op         ),
        .imm_src        (imm_src        ),
        .mem_write      (mem_write      ),
        .mem_to_reg     (mem_to_reg     ),        
        .alu_out        (alu_out        ),
        .zero           (zero           )
    );
    
    // Data memory
    dmem data_memory(
        .clk            (clk            ),
        .dmem_addr      (dmem_addr      ),
        .dmem_data_in   (dmem_data_in   ),
        .dmem_wr_en     (dmem_wr_en     ),
        .dmem_data_out  (dmem_data_out  )
    );
    
    //===========================================
    // This part loads the answer key memory.
    // This is meant for checking
    //===========================================

    logic [`BYTE_WIDTH-1:0] anskey_memory [0:4095];
    
    initial begin
        $readmemh("test_key.mem",anskey_memory);
    end
    
    //==========================================================
    // This section consists of all useful tasks
    //==========================================================
    
    // This task is for resetting
    task riscv_reset;
        clk  <= 1'b0;
        nrst <= 1'b0;
            
        #5;
            
        nrst <= 1'b1;
    endtask
    
    // Some useful simulation variables
    integer i;
    integer total_items;
    integer total_score;
    integer item_count;
    
    logic [`WORD_WIDTH-1:0] data_mem;
    logic [`WORD_WIDTH-1:0] anskey_mem;
    
    // This task is used for counting the scores
    task calculate_score;
    
        total_items = 0;
        total_score = 0;
        item_count = 32*4;
        
        $display(">> Data memory comparison log ============================");
        $display(">> Make sure to set the correct instruction memory, data memory, and answer key memory.");
        
        for(i=0; i < item_count; i=i+4) begin
    
            anskey_mem = {anskey_memory[i+32'd3],
                          anskey_memory[i+32'd2],
                          anskey_memory[i+32'd1],
                          anskey_memory[i]};
                                         
            data_mem = {data_memory.dmem_memory[i+32'd3],
                        data_memory.dmem_memory[i+32'd2],
                        data_memory.dmem_memory[i+32'd1],
                        data_memory.dmem_memory[i]};
            
            if(data_mem == anskey_mem) begin
                $display("Data mem:  %x;  Anskey mem: %x - CORRECT!", data_mem, anskey_mem);
                total_score = total_score + 1;
            end else begin
                $display("Data mem:  %x;  Anskey mem: %x - INCORRECT!", data_mem, anskey_mem);
            end
            
            total_items = total_items + 1;      
        end
        
        $display(">> Results log ============================");
        $display(">> Score: %d / %d", total_score, total_items);

    endtask
    
    //==========================================================
    // Always running components
    //==========================================================
    
    // Clock generation
    always begin #10; clk <= !clk; end
    
    // NOP unstruction catcher
    // This section simply tracks if we have 10 consecutive NOP instructions
    // If 10 consecutive NOPs was reached, calcuate the score and finish the simulation
    // Be warned that if you use too many nop instructions, this stops the simulation
    logic [4:0] nop_tracker;
    always_ff @ (posedge clk or negedge nrst) begin
        if(!nrst) begin
            nop_tracker <= 5'd0;
        end else begin
            if(imem_data == 32'h00000013) begin
                nop_tracker <= nop_tracker + 1;
            end else begin
                nop_tracker <= 5'd0;
            end
        end
        
        if(nop_tracker >= 5'd10) begin
            calculate_score;
            $finish;
        end
    end
    
    //==========================================================
    // Initial begin state just for resetting
    //==========================================================
    initial begin
        riscv_reset;
        #1000;
    end

endmodule
