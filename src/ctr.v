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


module ctr #(
	parameter ADR_WIDTH = `ADR_WIDTH
)(
	input wire clk_i,
	input wire rst_i,

	input wire carry_i,
	input wire [`OP_WIDTH-1:0] op_i,

	output reg [`CTR_MARMUX_WIDTH-1:0] ctr_marmux_o,
	output reg [`CTR_CARRYMUX_WIDTH-1:0] ctr_carrymux_o,
	output reg ctr_pc_reg_en_o,
	output reg ctr_a_reg_en_o,
	output reg ctr_mar_reg_en_o,
	output reg ctr_d_reg_en_o,
	output reg ctr_we_o,
	output reg [`OP_WIDTH-1:0] ctr_aluop_o

);
	localparam STATE_WIDTH = 12;
	localparam [STATE_WIDTH-1:0]
		s_fi	=	12'b000_000_000_001,
		s_rm	=	12'b000_000_000_010,
		s_nf	=	12'b000_000_000_100,
		s_nc	=	12'b000_000_001_000,
		s_af	=	12'b000_000_010_000,
		s_ac	=	12'b000_000_100_000,
		s_jc	=	12'b000_001_000_000,
		s_sw	=	12'b000_010_000_000,
		s_pm	=	12'b000_100_000_000,
		s_nw	=	12'b001_000_000_000,
		s_aw	=	12'b010_000_000_000,
		s_fw	=	12'b100_000_000_000;

	reg [STATE_WIDTH-1:0] current, next;


	always @(posedge clk_i) begin:sequential
		if (rst_i) begin
			current <= s_fi;
		end else begin
			current <= next;
		end
	end

	
	always @* begin:combnext
	case (current)
		s_fi:
			next = s_fw;
		s_fw:
			next = s_rm;
		s_rm:
			case (op_i)
				`OP_NOR : begin
					next = s_nf;
				end
				`OP_ADD : begin
					next = s_af;
				end
				`OP_STA : begin
					next = s_sw;
				end
				`OP_JCC : begin
					if (carry_i) begin
						next = s_jc;
					end else begin
						next = s_fi;
					end
				end
				default:
					next = s_fi;
			endcase
		s_nf:
			next = s_nw;
                s_nw:
                        next = s_nc;
		s_nc:
			next = s_pm;
		s_af:
			next = s_aw;
                s_aw:
                        next = s_ac;
		s_ac:
			next = s_pm;
		s_jc:
			next = s_pm;
		s_sw:
			next = s_pm;
		s_pm:
			next = s_fi;
		default:
			next = s_fi;
	endcase
	end


	always @* begin:combout
	case(current)
		s_fi:
		begin
			ctr_pc_reg_en_o = 1'b1;
			ctr_marmux_o = `MAR_OP_PC;
			ctr_mar_reg_en_o = 1'b0;
			ctr_aluop_o = `OP_ADD;
			ctr_a_reg_en_o = 1'b0;
			ctr_we_o = 1'b0;
			ctr_d_reg_en_o = 1'b0;
			ctr_carrymux_o = `CARRY_OP_KEEP;

		end
		s_fw:
		begin
			ctr_pc_reg_en_o = 1'b1;
			ctr_marmux_o = `MAR_OP_PC;
			ctr_mar_reg_en_o = 1'b0;
			ctr_aluop_o = `OP_ADD;
			ctr_a_reg_en_o = 1'b0;
			ctr_we_o = 1'b0;
			ctr_d_reg_en_o = 1'b1;
			ctr_carrymux_o = `CARRY_OP_KEEP;

		end
		s_rm:
		begin
			ctr_pc_reg_en_o = 1'b0;
			ctr_marmux_o = `MAR_OP_ARG;
			ctr_mar_reg_en_o = 1'b1;
			ctr_aluop_o = `OP_ADD;
			ctr_a_reg_en_o = 1'b0;
			ctr_we_o = 1'b0;
			ctr_d_reg_en_o = 1'b0;
			ctr_carrymux_o = `CARRY_OP_KEEP;

		end
		s_nf:
		begin
			ctr_pc_reg_en_o = 1'b0;
			ctr_marmux_o = `MAR_OP_PC;
			ctr_mar_reg_en_o = 1'b0;
			ctr_aluop_o = `OP_ADD;
			ctr_a_reg_en_o = 1'b0;
			ctr_we_o = 1'b0;
			ctr_d_reg_en_o = 1'b0;
			ctr_carrymux_o = `CARRY_OP_KEEP;

		end
		s_nw:
		begin
			ctr_pc_reg_en_o = 1'b0;
			ctr_marmux_o = `MAR_OP_PC;
			ctr_mar_reg_en_o = 1'b0;
			ctr_aluop_o = `OP_ADD;
			ctr_a_reg_en_o = 1'b0;
			ctr_we_o = 1'b0;
			ctr_d_reg_en_o = 1'b1;
			ctr_carrymux_o = `CARRY_OP_KEEP;

		end
		s_nc:
		begin
			ctr_pc_reg_en_o = 1'b0;
			ctr_marmux_o = `MAR_OP_PC;
			ctr_mar_reg_en_o = 1'b0;
			ctr_aluop_o = `OP_NOR;
			ctr_a_reg_en_o = 1'b1;
			ctr_we_o = 1'b0;
			ctr_d_reg_en_o = 1'b0;
			ctr_carrymux_o = `CARRY_OP_GEN;

		end
		s_af:
		begin
			ctr_pc_reg_en_o = 1'b0;
			ctr_marmux_o = `MAR_OP_PC;
			ctr_mar_reg_en_o = 1'b0;
			ctr_aluop_o = `OP_ADD;
			ctr_a_reg_en_o = 1'b0;
			ctr_we_o = 1'b0;
			ctr_d_reg_en_o = 1'b0;
			ctr_carrymux_o = `CARRY_OP_KEEP;

		end
		s_aw:
		begin
			ctr_pc_reg_en_o = 1'b0;
			ctr_marmux_o = `MAR_OP_PC;
			ctr_mar_reg_en_o = 1'b0;
			ctr_aluop_o = `OP_ADD;
			ctr_a_reg_en_o = 1'b0;
			ctr_we_o = 1'b0;
			ctr_d_reg_en_o = 1'b1;
			ctr_carrymux_o = `CARRY_OP_KEEP;

		end
		s_ac:
		begin
			ctr_pc_reg_en_o = 1'b0;
			ctr_marmux_o = `MAR_OP_PC;
			ctr_mar_reg_en_o = 1'b0;
			ctr_aluop_o = `OP_ADD;
			ctr_a_reg_en_o = 1'b1;
			ctr_we_o = 1'b0;
			ctr_d_reg_en_o = 1'b0;
			ctr_carrymux_o = `CARRY_OP_GEN;

		end
		s_jc:
		begin
			ctr_pc_reg_en_o = 1'b0;
			ctr_marmux_o = `MAR_OP_PC;
			ctr_mar_reg_en_o = 1'b0;
			ctr_aluop_o = `OP_ADD;
			ctr_a_reg_en_o = 1'b0;
			ctr_we_o = 1'b0;
			ctr_d_reg_en_o = 1'b0;
			ctr_carrymux_o = `CARRY_OP_CLR;

		end
		s_sw:
		begin
			ctr_pc_reg_en_o = 1'b0;
			ctr_marmux_o = `MAR_OP_PC;
			ctr_mar_reg_en_o = 1'b0;
			ctr_aluop_o = `OP_ADD;
			ctr_a_reg_en_o = 1'b0;
			ctr_we_o = 1'b1;
			ctr_d_reg_en_o = 1'b0;
			ctr_carrymux_o = `CARRY_OP_KEEP;

		end
		s_pm:
		begin
			ctr_pc_reg_en_o = 1'b0;
			ctr_marmux_o = `MAR_OP_PC;
			ctr_mar_reg_en_o = 1'b1;
			ctr_aluop_o = `OP_ADD;
			ctr_a_reg_en_o = 1'b0;
			ctr_we_o = 1'b0;
			ctr_d_reg_en_o = 1'b0;
			ctr_carrymux_o = `CARRY_OP_KEEP;

		end
		default:
		begin
			ctr_pc_reg_en_o = 1'b0;
			ctr_marmux_o = `MAR_OP_PC;
			ctr_mar_reg_en_o = 1'b1;
			ctr_aluop_o = `OP_ADD;
			ctr_a_reg_en_o = 1'b0;
			ctr_we_o = 1'b0;
			ctr_d_reg_en_o = 1'b0;
			ctr_carrymux_o = `CARRY_OP_KEEP;

		end
	endcase
	end


endmodule
