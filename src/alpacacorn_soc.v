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


module alpacacorn_soc #(
	parameter ADR_WIDTH = `ADR_WIDTH,
	parameter DATA_WIDTH = `DATA_WIDTH,
	parameter FILE = "tb/tb_alpacacorn_soc_i_sram_dual_port.hex"
)(
	input wire clk_i,
	input wire rst_n_i,

	input wire rs232_rx_i,
	output wire rs232_tx_o,
	input wire rts_n_i,
	output wire cts_n_o,
	input wire dtr_n_i,
	output wire dsr_n_o,
	output wire dcd_n_o,

	output wire [7:0] led_fpga_o

);

	wire rst;

	wire [DATA_WIDTH-1:0] data_sram_alpacacorn;
	wire [DATA_WIDTH-1:0] data_alpacacorn_sram;
	wire [ADR_WIDTH-1:0] adr_from_alpacacorn;
	wire we_from_alpacacorn;


	/* Toplevel module instantiations */
	rsthandler i_rsthandler(
		.clk_i(clk_i),
		.rst_button_n_i(rst_n_i),
		.rst_o(rst)
	);

	alpacacorn #(
		.ADR_WIDTH(ADR_WIDTH),
		.DATA_WIDTH(DATA_WIDTH)
	) i_alpacacorn (.clk_i(clk_i),
		.rst_i(rst),
		.data_i(data_sram_alpacacorn),
		.data_o(data_alpacacorn_sram),
		.adr_o(adr_from_alpacacorn),
		.we_o(we_from_alpacacorn)
	);

	sram_dual_port #(
		.DATA_WIDTH(DATA_WIDTH),
		.ADDR_WIDTH(ADR_WIDTH),
		.FILE(FILE)
	) i_sram_dual_port (.wclk_i(clk_i),
		.rclk_i(clk_i),
		.wen_i(we_from_alpacacorn),
		.waddr_i(adr_from_alpacacorn),
		.raddr_i(adr_from_alpacacorn),
		.data_i(data_alpacacorn_sram),
		.data_o(data_sram_alpacacorn)
	);

	wire [6:0] id_from_led;

	led #(
		.CONFIG_ID(`ALPACACORN_CONFIG_ID)
	) i_led (
		.clk_i(clk_i),
		.rst_i(rst),
		.led_o(id_from_led)
	);


	wire [11:0] count_led;
	wire en_snif_count;

	snif #(
		.ADR_WIDTH(ADR_WIDTH)
	) i_snif (
		.clk_i(clk_i),
		.rst_i(rst),
		.adr_i(adr_from_alpacacorn),
		.we_i(we_from_alpacacorn),
		.detect_o(en_snif_count)
	);

	count #(
		.WIDTH(12)
	) i_count (
		.clk_i(clk_i),
		.rst_i(rst),
		.en_i(en_snif_count),
		.count_o(count_led)
	);


	assign dsr_n_o = 0;
	assign dcd_n_o = 0;
	assign cts_n_o = 0;
	assign rs232_tx_o = 1;
	assign led_fpga_o = {count_led[11], id_from_led};

endmodule
