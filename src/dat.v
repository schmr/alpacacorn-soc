/* Accumulator-based CPU core
 * Copyright Robert Schmidt <rschmidt@uni-bremen.de>, 2020
 *
 * This documentation describes Open Hardware and is licensed under the
 * CERN-OHL-W v2.
 *
 * You may redistribute and modify this documentation under the terms
 * of the CERN-OHL-W v2. (https://cern.ch/cern-ohl). This documentation
 * is distributed WITHOUT ANY EXPRESS OR IMPLIED WARRANTY, INCLUDING OF
 * MERCHANTABILITY, SATISFACTORY QUALITY AND FITNESS FOR A PARTICULAR
 * PURPOSE. Please see the CERN-OHL-W v2 for applicable conditions.
 */

`include "alpacacorn.vh"


module dat #(
	parameter DATA_WIDTH = `DATA_WIDTH
)(
	input wire clk_i,
	input wire rst_i,

	input wire [DATA_WIDTH-1:0] data_i,
	input wire [`OP_WIDTH-1:0] ctr_aluop_i,
	input wire ctr_a_reg_en_i,
	input wire [`CTR_CARRYMUX_WIDTH-1:0] ctr_carrymux_i,

	output wire carry_o,
	output wire [DATA_WIDTH-1:0] data_o
);
	reg [DATA_WIDTH-1:0] a_reg;
	reg [DATA_WIDTH-1:0] a_reg_next;
	reg carry_reg;
	reg carry_next;
	reg carry_alu;


	always @(posedge clk_i) begin:seq
		if (rst_i) begin
			a_reg <= 0;
			carry_reg <= 0;
		end else begin
			if (ctr_a_reg_en_i) begin
				a_reg <= a_reg_next;
			end
			carry_reg <= carry_next;
		end
	end


	always @* begin:comb
		case (ctr_aluop_i)
			`OP_NOR : begin
				{carry_alu, a_reg_next} =
					{1'b0, ~(a_reg | data_i)};
			end
			`OP_ADD : begin
				{carry_alu, a_reg_next} =
					a_reg + data_i;
			end
			`OP_JCC : begin
				{carry_alu, a_reg_next} = {1'b0, a_reg};
			end
			`OP_STA : begin
				{carry_alu, a_reg_next} = {carry_reg, a_reg};
			end
			default:
				{carry_alu, a_reg_next} = {carry_reg, a_reg};
		endcase

		case (ctr_carrymux_i)
			`CARRY_OP_KEEP : begin
				carry_next = carry_reg;
			end
			`CARRY_OP_GEN : begin
				carry_next = carry_alu;
			end
			`CARRY_OP_CLR : begin
				carry_next = 0;
			end
			default:
				carry_next = carry_reg;
		endcase
				
	end


	assign data_o = a_reg;
	assign carry_o = carry_reg;


endmodule
