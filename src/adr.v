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


module adr #(
	parameter ADR_WIDTH = `ADR_WIDTH
)(
	input wire clk_i,
	input wire rst_i,

	input wire [ADR_WIDTH-1:0] adr_i,
	input wire [`CTR_MARMUX_WIDTH-1:0] ctr_marmux_i,
	input wire ctr_mar_reg_en_i,
	input wire ctr_pc_reg_en_i,

	output wire [ADR_WIDTH-1:0] adr_o
);
	reg [ADR_WIDTH-1:0] mar_reg;
	reg [ADR_WIDTH-1:0] mar_reg_next;
	reg [ADR_WIDTH-1:0] pc_reg;
	reg [ADR_WIDTH-1:0] pc_reg_next;


	always @(posedge clk_i) begin:seq
		if (rst_i) begin
			pc_reg <= 0;
			mar_reg <= 0;
		end else begin
			if (ctr_pc_reg_en_i) begin
				pc_reg <= pc_reg_next;
			end
			if (ctr_mar_reg_en_i) begin
				mar_reg <= mar_reg_next;
			end
		end
	end


	always @* begin:comb
		pc_reg_next = mar_reg + 1'd1;
		case (ctr_marmux_i)
			`MAR_OP_ARG : begin
				mar_reg_next = adr_i;
			end
			`MAR_OP_PC : begin
				mar_reg_next = pc_reg;
			end
			default:
				mar_reg_next = pc_reg;
		endcase
	end


	assign adr_o = mar_reg;


endmodule
