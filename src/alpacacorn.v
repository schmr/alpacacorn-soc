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


module alpacacorn #(
	parameter ADR_WIDTH = `ADR_WIDTH,
	parameter DATA_WIDTH = `DATA_WIDTH
)(
	input wire clk_i,
	input wire rst_i,

	input wire [DATA_WIDTH-1:0] data_i,

	output wire [DATA_WIDTH-1:0] data_o,
	output wire [ADR_WIDTH-1:0] adr_o,
	output wire we_o
);

	wire carry_dat_ctr;
	wire [`CTR_CARRYMUX_WIDTH-1:0] ctr_carrymux_ctr_dat;
	wire ctr_a_reg_en_ctr_dat;
	wire [`CTR_MARMUX_WIDTH-1:0] ctr_marmux_ctr_adr;
	wire ctr_mar_reg_en_ctr_adr;
	wire ctr_pc_reg_en_ctr_adr;
	wire ctr_d_reg_en;
	wire [`OP_WIDTH-1:0] ctr_aluop_ctr_dat;
	reg [DATA_WIDTH-1:0] d_reg;


	always @(posedge clk_i) begin:seq
		if (rst_i) begin
			d_reg <= 0;
		end else begin
			if (ctr_d_reg_en) begin
				d_reg <= data_i;
			end
		end
	end
		

	ctr #(
		.ADR_WIDTH(ADR_WIDTH)
	) i_ctr (
		.clk_i(clk_i),
		.rst_i(rst_i),

		.carry_i(carry_dat_ctr),
		.op_i(d_reg[DATA_WIDTH-1:DATA_WIDTH-`OP_WIDTH]),
		
		.ctr_marmux_o(ctr_marmux_ctr_adr),
		.ctr_carrymux_o(ctr_carrymux_ctr_dat),
		.ctr_a_reg_en_o(ctr_a_reg_en_ctr_dat),
		.ctr_d_reg_en_o(ctr_d_reg_en),
		.ctr_mar_reg_en_o(ctr_mar_reg_en_ctr_adr),
		.ctr_pc_reg_en_o(ctr_pc_reg_en_ctr_adr),
		.ctr_aluop_o(ctr_aluop_ctr_dat),

		.ctr_we_o(we_o)
	);


	adr #(
		.ADR_WIDTH(ADR_WIDTH)
	) i_adr (
		.clk_i(clk_i),
		.rst_i(rst_i),

		.adr_i(d_reg[ADR_WIDTH-1:0]),
		.ctr_marmux_i(ctr_marmux_ctr_adr),
		.ctr_mar_reg_en_i(ctr_mar_reg_en_ctr_adr),
		.ctr_pc_reg_en_i(ctr_pc_reg_en_ctr_adr),

		.adr_o(adr_o)
	);


	dat #(
		.DATA_WIDTH(DATA_WIDTH)
	) i_dat (
		.clk_i(clk_i),
		.rst_i(rst_i),

		.data_i(d_reg),
		.ctr_aluop_i(ctr_aluop_ctr_dat),
		.ctr_carrymux_i(ctr_carrymux_ctr_dat),
		.ctr_a_reg_en_i(ctr_a_reg_en_ctr_dat),

		.carry_o(carry_dat_ctr),
		.data_o(data_o)
	);


endmodule
