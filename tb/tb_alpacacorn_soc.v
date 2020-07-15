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


module tb_alpacacorn_soc #(
	parameter ADR_WIDTH = `ADR_WIDTH,
	parameter DATA_WIDTH = `DATA_WIDTH
)();
	reg clk;
	reg rst_n;

	reg rs232_rx_i;
	wire rs232_tx_o;
	reg rts_n_i;
	wire cts_n_o;
	reg dtr_n_i;
	wire dsr_n_o;
	wire dcd_n_o;
	wire [7:0] led_fpga_o;

	integer j;


	alpacacorn_soc #(
		.ADR_WIDTH(ADR_WIDTH),
		.DATA_WIDTH(DATA_WIDTH),
	.FILE("tb/tb_alpacacorn_soc_i_sram_dual_port.hex")
	) i_alpacacorn_soc (.clk_i(clk),
		.rst_n_i(rst_n),

	.rs232_rx_i(rs232_rx_i),
	.rs232_tx_o(rs232_tx_o),
	.rts_n_i(rts_n_i),
	.cts_n_o(cts_n_o),
	.dtr_n_i(dtr_n_i),
	.dsr_n_o(dsr_n_o),
	.dcd_n_o(dcd_n_o),
	.led_fpga_o(led_fpga_o)
	);



	initial begin
		$dumpfile("tb_alpacacorn_soc.vcd");
		// $dumpvars(level, list_of_variables_or_modules)
		// level = 1 -> only variables in list_of_variables_or_modules
		$dumpvars(0, tb_alpacacorn_soc);
		//$readmemb("tb/egse.stim", stim);
		//$monitor("%b%b LED:%b RS232TX:%b", clk, rst_n, led, rs232_tx);

		clk = 0;
		rst_n = 0;
        	rs232_rx_i = 1;
        	rts_n_i = 1;
        	dtr_n_i = 1;
		#10 rst_n = 1;
		/* Run for some time */
		for (j = 0; j < 20000000; j = j + 1)
		begin
			@(posedge clk);
		end
		$finish;
	end

	always
		#1 clk = !clk;

endmodule
