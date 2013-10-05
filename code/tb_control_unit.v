`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:11:43 10/05/2013
// Design Name:   control_unit
// Module Name:   M:/01/code/tb_control_unit.v
// Project Name:  code
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: control_unit
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_control_unit;

	// Inputs
	reg clock;
	reg [5:0] instruction_opcode;
	reg [5:0] instruction_func;
	reg reset;

	// Outputs
	wire register_destination;
	wire branch;
	wire memory_to_register;
	wire [5:0] alu_func;
	wire memory_write;
	wire alu_source;
	wire register_write;
	wire jump;
	wire shift_swap;

	// Instantiate the Unit Under Test (UUT)
	control_unit uut (
		.clock(clock), 
		.instruction_opcode(instruction_opcode), 
		.instruction_func(instruction_func), 
		.reset(reset), 
		.register_destination(register_destination), 
		.branch(branch), 
		.memory_to_register(memory_to_register), 
		.alu_func(alu_func), 
		.memory_write(memory_write), 
		.alu_source(alu_source), 
		.register_write(register_write), 
		.jump(jump), 
		.shift_swap(shift_swap)
	);

	initial begin
		// Initialize Inputs
		clock = 0;
		instruction_opcode = 0;
		instruction_func = 0;
		reset = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

