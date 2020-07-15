/* Dual port RAM module
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

module sram_dual_port #(
	parameter DATA_WIDTH = 8,
	parameter ADDR_WIDTH = 9,
	parameter FILE = ""
)(
	input wire wclk_i,
	input wire rclk_i,
	input wire wen_i,

	input wire [ADDR_WIDTH-1:0] waddr_i,
	input wire [DATA_WIDTH-1:0] data_i,
	
	input wire [ADDR_WIDTH-1:0] raddr_i,
	output reg [DATA_WIDTH-1:0] data_o
);

	reg [DATA_WIDTH-1:0] mem [(1<<ADDR_WIDTH)-1:0];

	initial
	begin
		if (FILE != "") $readmemh(FILE, mem);
	end


	always @(posedge wclk_i)
	begin
		if (wen_i)
			mem[waddr_i] <= data_i;
	end


	always @(posedge rclk_i)
	begin
		data_o <= mem[raddr_i];
	end
			

endmodule
