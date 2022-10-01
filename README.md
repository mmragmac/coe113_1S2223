# coe113_1S2223
A single-cycle processor written in SystemVerilog.

## riscv_reg.sv
Contains module **riscv_reg**. It has 32 32-bit registers that reset to zero when *nrst* is set to 0. It has asynchronous reads and synchronous writes. It does not allow writes to *register[0]*, whose value is set to *32'd0*.

## riscv_comb_controller.sv
Contains module **risc_comb_controller**. It is an asynchronous module that outputs the required control signals. It mainly uses two case blocks: one for identifying the operation using the *opcode* and *funct* values, the other for setting the appropriate control signals depending on the operation identified in the first case block.

## riscv_alu.sv
Contains module **risc_alu**. It performs 6 basic operations on the provided operands and returns a 32-bit output. It also returns a signal *zero* to show whether or not the ALU's output is equal to 0 which is useful for the *branch* instructions.

## risc_imm.sv
Contains module **risc_imm**. This module rearranges the immediate from the provided instruction depending on the appropriate *imm_src*  signal sent by the controller module.

## risc_pc.sv
Contains module **risc_pc**. This module updates synchronously but can reset asynchronously. With R- and I-type instructions, **risc_pc** typically updates with *PC+4*. When using *jump* or *branch* instructions, **risc_pc** may instead add the current value of the program counter to an immediate offset for the next instruction.

## risc_muxes.sv
Contains modules **risc_mux_alu** and **risc_mux_result**, both having 32-bit outputs. **risc_mux_alu** selects the input for the second operand of the 'main' ALU. **risc_mux_result** selects the input for the data being written into the register file.

## risc_core.sv
Contains module **riscv_core**. Aside from having one instance of each of the other modules, the slicing of the current instruction happens here. As instructed in the specs, the ports were not modified in any way.
