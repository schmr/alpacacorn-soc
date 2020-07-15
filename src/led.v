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


module led #(
	parameter CONFIG_ID = `ALPACACORN_CONFIG_ID
)(
	input wire clk_i,
	input wire rst_i,
	output wire [6:0] led_o
);

	reg [7:0] led_reg;


	always @(posedge clk_i) begin : sequential
		if (rst_i) begin
			led_reg <= 7'b0000000;
		end else begin
			led_reg <= CONFIG_ID;

		end
	end

	assign led_o = led_reg;

endmodule
