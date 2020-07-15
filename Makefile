.SHELL=sh
top := alpacacorn_soc
srcfiles := adr.v dat.v ctr.v alpacacorn.v led.v async_reset_sync2.v rsthandler.v ${top}.v sram_dual_port.v snif.v count.v
src := $(addprefix src/,${srcfiles})
incfiles := alpacacorn.vh
incdir := src/inc
src_inc := $(addprefix src/inc/,${incfiles})
# Target for Lattice ice40HX8K dev board
fpga_board := ice40hx8k-ct256_fpga_eb85_board
fpga_model := hx8k
fpga_package := ct256
# Target for dummy board with smaller FPGA
#fpga_board := ice40hx1k-vq100-dummy
#fpga_model := hx1k
#fpga_package := vq100


simcmd := iverilog -g2005 -I${incdir}

all: ${top}.bin ${top}.pbm
#all: tb_alpacacorn_soc.vcd
#all: tb_adr.vcd tb_dat.vcd tb_alpacacorn.vcd
#all: ${top}.bin #tb_dat.vcd tb_adr.vcd tb_alpacacorn.vcd # ${top}.bin


${top}.bin: ${top}.asc
	icepack $< $@

${top}.pbm: ${top}.asc
	icepack -r $< $@

${top}.asc: tec/${fpga_board}_${top}.pcf ${top}.json
	#arachne-pnr -d 8k -p $< -o $@ ${top}.blif 2>&1 | tee ${top}.arachne.log
	nextpnr-ice40 --${fpga_model} --package ${fpga_package} --json ${top}.json --pcf tec/${fpga_board}_${top}.pcf --asc $@ 2>&1 | tee ${top}.nextpnr.log

${top}.placed.svg: tec/${fpga_board}_${top}.pcf ${top}.json
	nextpnr-ice40 --${fpga_model} --package ${fpga_package} --json ${top}.json --pcf tec/${fpga_board}_${top}.pcf --placed-svg $@

${top}.routed.svg: tec/${fpga_board}_${top}.pcf ${top}.json
	nextpnr-ice40 --${fpga_model} --package ${fpga_package} --json ${top}.json --pcf tec/${fpga_board}_${top}.pcf --routed-svg $@

#${top}.blif: ${src} | tb_${top}.vcd
${top}.json: ${src}
	yosys -l ${top}.yosys.log -v2 -p " \
	              verilog_defaults -add -I ${incdir}; \
	              read_verilog src/adr.v; \
	              read_verilog src/dat.v; \
	              read_verilog src/ctr.v; \
	              read_verilog src/alpacacorn.v; \
	              read_verilog src/async_reset_sync2.v; \
	              read_verilog src/rsthandler.v; \
	              read_verilog src/led.v; \
	              read_verilog src/snif.v; \
	              read_verilog src/count.v; \
	              read_verilog src/sram_dual_port.v; \
	              read_verilog src/${top}.v; \
	              synth_ice40 -abc2 -top ${top} -json $@"

tec/${fpga_board}_${top}.pcf: tec/${fpga_board}.pcf tec/${top}-${fpga_package}.pcf
	cat $^ >$@

tb_%.vcd: tb_%
	./$<

tb_alpacacorn: tb/tb_alpacacorn.v ${src} ${src_inc} tb/tb_alpacacorn_i_sram_dual_port.hex
	${simcmd} -o $@ $< ${src}

tb_%: tb/tb_%.v ${src} ${src_inc}
	${simcmd} -o $@ $< ${src}


clean:
	-rm *.vcd tb_* *.json *.bin tec/${fpga_board}_${top}.pcf *.log *.pbm *.svg *.asc

.PHONY: clean
