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


module count #(
	parameter WIDTH = 12
)(
	input wire clk_i,
	input wire rst_i,
        input wire en_i,
	output wire [WIDTH-1:0] count_o
);

	reg [WIDTH-1:0] count_reg;


	always @(posedge clk_i) begin : sequential
		if (rst_i) begin
			count_reg <= 0;
		end else begin
			if (en_i) begin
				count_reg <= count_reg + 1;
			end
		end
	end

	assign count_o = count_reg;

endmodule
