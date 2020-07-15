/* Reset signal generation module
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

module rsthandler
(
	input wire clk_i,
	input wire rst_button_n_i,
	output wire rst_o
);

	wire rst_button_n;

	async_reset_sync2 i_async_reset_sync2(
		.clk_i(clk_i),
		.rst_n_i(rst_button_n_i),
		.rst_n_o(rst_button_n));

	assign rst_o = ~rst_button_n;

endmodule
