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

`timescale 1ns/10ps
`include "alpacacorn.vh"


module tb_adr #(
	parameter ADR_WIDTH = 5
)();
	reg clk;
	reg rst;
	reg [ADR_WIDTH-1:0] adr_i;
	reg [`CTR_MARMUX_WIDTH-1:0] ctr_marmux_i;
	reg ctr_mar_reg_en_i;
	reg ctr_pc_reg_en_i;
	wire [ADR_WIDTH-1:0] adr_o;

	integer j;


	adr #(
		.ADR_WIDTH(ADR_WIDTH)
	) i_adr (.clk_i(clk),
		.rst_i(rst),
		.adr_i(adr_i),
		.ctr_marmux_i(ctr_marmux_i),
		.ctr_mar_reg_en_i(ctr_mar_reg_en_i),
		.ctr_pc_reg_en_i(ctr_pc_reg_en_i),
		.adr_o(adr_o)
	);


	initial begin
		$dumpfile("tb_adr.vcd");
		// $dumpvars(level, list_of_variables_or_modules)
		// level = 1 -> only variables in list_of_variables_or_modules
		$dumpvars(0, tb_adr);
		//$readmemb("tb/egse.stim", stim);
		//$monitor("%b%b LED:%b RS232TX:%b", clk, rst_n, led, rs232_tx);


		/* Reset circuit */
		clk = 0;
		rst = 1;
		ctr_marmux_i = `MAR_OP_ARG;
		ctr_mar_reg_en_i = 1'b0;
		ctr_pc_reg_en_i = 1'b0;
		adr_i = 0;
		#10 rst = 0;

		/* Initialize MAR from adr_i */
		ctr_marmux_i = `MAR_OP_ARG;
		ctr_mar_reg_en_i = 1'b1;
		ctr_pc_reg_en_i = 1'b0;
		for (j = 0; j < 2**ADR_WIDTH; j = j + 1)
		begin
			adr_i = j;
			@(posedge clk);
			#1 if (adr_o != adr_i) begin
				$display("MAR_OP_ARG fail: j=%d", j);
			end
		end
		/* Protect MAR state */
		ctr_marmux_i = `MAR_OP_ARG;
		ctr_mar_reg_en_i = 1'b1;
		ctr_pc_reg_en_i = 1'b0;
		adr_i = 26;
		@(posedge clk);
		#1;
		ctr_mar_reg_en_i = 1'b0;
		for (j = 0; j < 2**ADR_WIDTH; j = j + 1)
		begin
			adr_i = j;
			@(posedge clk);
			#1 if (adr_o != 26) begin
				$display("Protect MAR state fail: j=%d", j);
			end
		end
		/* Initialize MAR from PC */
		/* Let adr_i count up as well and assert difference */
		ctr_marmux_i = `MAR_OP_ARG;
		ctr_mar_reg_en_i = 1'b1;
		ctr_pc_reg_en_i = 1'b1;
		adr_i = 0;
		@(posedge clk); /* 0 to MAR */
		@(posedge clk); /* 1 to PC */
		ctr_marmux_i = `MAR_OP_PC;
		ctr_mar_reg_en_i = 1'b1;
		ctr_pc_reg_en_i = 1'b1;
		@(posedge clk);
		@(posedge clk);
		for (j = 0; j < 2**ADR_WIDTH; j = j + 1)
		begin
			adr_i = j;
			@(posedge clk);
			@(posedge clk);
			if (adr_o == adr_i) begin
				$display("MAR_OP_PC fail: j=%d", j);
			end
		end

		$finish;
	end

	always
		#1 clk = !clk;

endmodule
