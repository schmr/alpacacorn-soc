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


module tb_alpacacorn #(
	parameter ADR_WIDTH = `ADR_WIDTH,
	parameter DATA_WIDTH = `DATA_WIDTH
)();
	reg clk;
	reg rst;
	wire [DATA_WIDTH-1:0] data_sram_alpacacorn;

	wire [DATA_WIDTH-1:0] data_alpacacorn_sram;
	wire [ADR_WIDTH-1:0] adr_alpacacorn_sram;
	wire we_alpacacorn_sram;

	integer j;


	alpacacorn #(
		.ADR_WIDTH(ADR_WIDTH),
		.DATA_WIDTH(DATA_WIDTH)
	) i_alpacacorn (.clk_i(clk),
		.rst_i(rst),
		.data_i(data_sram_alpacacorn),
		.data_o(data_alpacacorn_sram),
		.adr_o(adr_alpacacorn_sram),
		.we_o(we_alpacacorn_sram)
	);

	sram_dual_port #(
		.DATA_WIDTH(DATA_WIDTH),
		.ADDR_WIDTH(ADR_WIDTH),
		.FILE("tb/tb_alpacacorn_i_sram_dual_port.hex")
	) i_sram_dual_port (.wclk_i(clk),
		.rclk_i(clk),
		.wen_i(we_alpacacorn_sram),
		.waddr_i(adr_alpacacorn_sram),
		.raddr_i(adr_alpacacorn_sram),
		.data_i(data_alpacacorn_sram),
		.data_o(data_sram_alpacacorn)
	);


	initial begin
		$dumpfile("tb_alpacacorn.vcd");
		// $dumpvars(level, list_of_variables_or_modules)
		// level = 1 -> only variables in list_of_variables_or_modules
		$dumpvars(0, tb_alpacacorn);
		//$readmemb("tb/egse.stim", stim);
		//$monitor("%b%b LED:%b RS232TX:%b", clk, rst_n, led, rs232_tx);

		clk = 0;
		rst = 1;
		#10 rst = 0;
		/* Run for some time */
		for (j = 0; j < 420; j = j + 1)
		begin
			@(posedge clk);
		end
		$finish;
	end

	always
		#1 clk = !clk;

endmodule
