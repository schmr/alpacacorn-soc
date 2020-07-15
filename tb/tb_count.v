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


module tb_count #(
	parameter WIDTH = 4
)();
	reg clk;
	reg rst;

	reg en_i;

	wire [WIDTH-1:0] count_o;


	integer j;


	count #(
		.WIDTH(WIDTH)
	) i_count (.clk_i(clk),
		.rst_i(rst),

		.en_i(en_i),

		.count_o(count_o)
	);


	initial begin
		$dumpfile("tb_count.vcd");
		// $dumpvars(level, list_of_variables_or_modules)
		// level = 1 -> only variables in list_of_variables_or_modules
		$dumpvars(0, tb_count);
		//$readmemb("tb/egse.stim", stim);
		//$monitor("%b%b LED:%b RS232TX:%b", clk, rst_n, led, rs232_tx);

		clk = 0;
		rst = 1;
		en_i = 1'b0;
		#10 rst = 0;
		@(posedge clk)
		/* Wait some cycles without enabling */
		for (j = 0; j < 5; j = j + 1)
		begin
			@(posedge clk)
			if (count_o != 0) begin
				$display("Invalid count: j=%d", j);
			end
		end
		@(posedge clk);
		/* Enable counter */
		en_i = 1'b1;
		for (j = 0; j < 15; j = j + 1)
		begin
			@(posedge clk)
			if (count_o != j+1) begin
				$display("Missing count: j=%d", j);
			end
		end
		@(posedge clk);


		$finish;
	end

	always
		#1 clk = !clk;

endmodule
