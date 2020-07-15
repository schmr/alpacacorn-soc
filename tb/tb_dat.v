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


module tb_dat #(
	parameter DATA_WIDTH = 8
)();
	reg clk;
	reg rst;

	reg [DATA_WIDTH-1:0] data_i;
	reg [`OP_WIDTH-1:0] ctr_aluop_i;
	reg ctr_a_reg_en_i;
	reg [`CTR_CARRYMUX_WIDTH-1:0] ctr_carrymux_i;

	wire carry_o;
	wire [DATA_WIDTH-1:0] data_o;


	integer j;


	dat #(
		.DATA_WIDTH(DATA_WIDTH)
	) i_dat (.clk_i(clk),
		.rst_i(rst),

		.data_i(data_i),
		.ctr_aluop_i(ctr_aluop_i),
		.ctr_carrymux_i(ctr_carrymux_i),
		.ctr_a_reg_en_i(ctr_a_reg_en_i),

		.carry_o(carry_o),
		.data_o(data_o)
	);


	initial begin
		$dumpfile("tb_dat.vcd");
		// $dumpvars(level, list_of_variables_or_modules)
		// level = 1 -> only variables in list_of_variables_or_modules
		$dumpvars(0, tb_dat);
		//$readmemb("tb/egse.stim", stim);
		//$monitor("%b%b LED:%b RS232TX:%b", clk, rst_n, led, rs232_tx);

		clk = 0;
		rst = 1;
		data_i = 8'b00000000;
		ctr_aluop_i = `OP_ADD;
		ctr_carrymux_i = `CARRY_OP_GEN;
		ctr_a_reg_en_i = 1'b0;
		#10 rst = 0;
		@(posedge clk)
		/* Add zero to accumulator */
		ctr_a_reg_en_i = 1'b1;
		for (j = 0; j < 10; j = j + 1)
		begin
			@(posedge clk)
			if (data_o != data_i) begin
				$display("Add zero fail: j=%d", j);
			end
			if (carry_o != 1'b0) begin
				$display("Add zero carry fail: j=%d", j);
			end
		end
		/* Keep state */
		data_i = 8'b01011001;
		ctr_a_reg_en_i = 1'b0;
		for (j = 0; j < 10; j = j + 1)
		begin
			@(posedge clk)
			if (data_o == data_i) begin
				$display("Keep state fail: j=%d", j);
			end
		end
		/* Add one to accumulator */
		data_i = 8'b00000001;
		@(posedge clk);
		ctr_a_reg_en_i = 1'b1;
		for (j = 1; j < 2**DATA_WIDTH; j = j + 1)
		begin
			@(posedge clk);
			if (data_o != j) begin
				$display("Add one fail: j=%d", j);
			end
		end
		@(posedge clk);
		if (carry_o != 1'b1) begin
			$display("Carry generation fail");
		end
		/* Clear carry */
		data_i = 8'b00000000;
		ctr_aluop_i = `OP_JCC;
		ctr_carrymux_i = `CARRY_OP_CLR;
		ctr_a_reg_en_i = 1'b0;
		@(posedge clk)
		if (carry_o != 1'b0) begin
			$display("Carry clear fail");
		end
		/* NOR zero accumulator content with all zero to get all one */
		data_i = 8'b00000000;
		ctr_aluop_i = `OP_NOR;
		ctr_carrymux_i = `CARRY_OP_CLR;
		ctr_a_reg_en_i = 1'b1;
		@(posedge clk)
		#1 if (data_o != 8'b1111_1111) begin
			$display("NOR with zero fail");
		end
		/* NOR all one accumulator with all one to get all zero */
		data_i = 8'b1111_1111;
		ctr_aluop_i = `OP_NOR;
		ctr_carrymux_i = `CARRY_OP_CLR;
		ctr_a_reg_en_i = 1'b1;
		@(posedge clk)
		#1 if (data_o != 0) begin
			$display("NOR with one fail");
		end
		


		$finish;
	end

	always
		#1 clk = !clk;

endmodule
