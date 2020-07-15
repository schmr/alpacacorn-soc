/* Bus last address write sniffer
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


module snif #(
	parameter ADR_WIDTH = `ADR_WIDTH
)(
	input wire clk_i,
	input wire rst_i,

	input wire [ADR_WIDTH-1:0] adr_i,
	input wire we_i,

	output wire detect_o
);
	reg pulse_reg;
	reg pulse_reg_next;
	reg detect;


	always @(posedge clk_i) begin:seq
		if (rst_i) begin
			pulse_reg <= 0;
		end else begin
			pulse_reg <= pulse_reg_next;
		end
	end


	always @* begin:comb
		pulse_reg_next = &{adr_i, we_i};
		detect = pulse_reg && !pulse_reg_next;
	end


	assign detect_o = detect;


endmodule
