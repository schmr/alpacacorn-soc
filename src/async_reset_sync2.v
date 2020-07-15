/* Asynchronous reset synchronizer module
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

module async_reset_sync2(
	input wire clk_i,
	input wire rst_n_i,
	output reg rst_n_o
);
	
	reg rff1;

	always @(posedge clk_i or negedge rst_n_i) begin
		if (!rst_n_i) {rst_n_o, rff1} <= 2'b0;
		else          {rst_n_o, rff1} <= {rff1, 1'b1};
	end

endmodule
