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


module tb_snif #(
	parameter ADR_WIDTH = 6
)();
	reg clk;
	reg rst;

	reg [ADR_WIDTH-1:0] adr_i;
	reg we_i;

	wire detect_o;


	integer j;


	snif #(
		.ADR_WIDTH(ADR_WIDTH)
	) i_snif (.clk_i(clk),
		.rst_i(rst),

		.adr_i(adr_i),
		.we_i(we_i),

		.detect_o(detect_o)
	);


	initial begin
		$dumpfile("tb_snif.vcd");
		// $dumpvars(level, list_of_variables_or_modules)
		// level = 1 -> only variables in list_of_variables_or_modules
		$dumpvars(0, tb_snif);
		//$readmemb("tb/egse.stim", stim);
		//$monitor("%b%b LED:%b RS232TX:%b", clk, rst_n, led, rs232_tx);

		clk = 0;
		rst = 1;
		adr_i = 6'b000_000;
		we_i = 1'b0;
		#10 rst = 0;
		@(posedge clk)
		/* Traverse through all addresses without write enable */
		for (j = 0; j < 64; j = j + 1)
		begin
			@(posedge clk)
			adr_i = j;
			if (detect_o != 1'b0) begin
				$display("Detect without write: j=%d", j);
			end
		end
		@(posedge clk);
		/* Traverse through false addresses with write enable */
		we_i = 1'b1;
		for (j = 0; j < 63; j = j + 1)
		begin
			adr_i = j;
			@(posedge clk)
			if (detect_o != 1'b0) begin
				$display("Detect false address: j=%d", j);
			end
		end
		@(posedge clk);
		/* Detect last address write */
		adr_i = 63;
		we_i = 1'b1;
		@(posedge clk);
		we_i = 1'b0;
		@(posedge clk);
		if (detect_o != 1'b1) begin
			$display("No detect!");
		end
		@(posedge clk);
		


		$finish;
	end

	always
		#1 clk = !clk;

endmodule
