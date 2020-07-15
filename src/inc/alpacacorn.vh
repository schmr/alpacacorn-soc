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

`ifndef _alpacacorn_vh_
`define _alpacacorn_vh_

`define CTR_MARMUX_WIDTH	1
`define MAR_OP_ARG		1'b0
`define MAR_OP_PC		1'b1


`define OP_WIDTH		2
`define OP_NOR			2'b00
`define OP_ADD			2'b01
`define OP_STA			2'b10
`define OP_JCC			2'b11

`define CTR_CARRYMUX_WIDTH	2
`define CARRY_OP_KEEP		2'b00
`define CARRY_OP_GEN		2'b01
`define CARRY_OP_CLR		2'b10


`define DATA_WIDTH		8
`define ADR_WIDTH		6


`define ALPACACORN_CONFIG_ID	1		

`endif
