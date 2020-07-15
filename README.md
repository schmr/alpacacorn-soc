# alpacacorn-soc
> A minimal system-on-chip featuring a tiny CPU with accumulator-based architecture
![Logo featuring an Alpaca over a rainbow background](doc/img/logo.png)

The whole SoC and CPU design aims to be simple and easy to implement for tool chain development and research.
It is barely a system-on-chip,
but features a CPU core, SRAM, and additional hardware to monitor and visualize a heart beat signal of the CPU executing an endless program.
While there is no assembler yet, the small ISA and flat memory model allows to assemble toy programs by hand.
Here is an example:

```
# Example program running a loop of 10 iterations:
# for (i = 0, i < 10, i++) {
#     pass
# }

# ADR   LABEL       CODE           COMMENT     BIN                HEX


                    # Do not assume carry is clear by reset.
00                  JCC loop                   11_00_0101         C5
01                  JCC loop                   11_00_0101         C5

02      inc:        db 1                        0000_0001         01
03      limit:      db -10                      1111_0110         F6
04      i:          db 0                        0000_0000         00

        loop:       # empty loop body
                    # i++
                    # LOD i, ADD inc
05                  NOR minusone   # CLR       00_00_1011         0D
06                  ADD i                      01_00_0100         44
07                  ADD inc                    01_00_0010         42
08                  STO i                      10_00_0100         84

                    # i < 10?
09                  ADD limit                  01_00_0011         43
10                  JCC loop                   11_00_0101         C5

11      end:        JCC end        # JMP end   11_00_1011         CB
12                  JCC end                    11_00_1011         CB

13      minusone:   db -1                       1111_1111         FF
```

Further examples are in the testbench folder `tb/`.


## Building

To synthesize the design run `make`,
which creates a bitstream for the FPGA.

To run the simulations with icarus verilog,
run `make tb_alpacacorn.vcd`.


## Prerequisites

The following software needs to be installed on the development machine to recreate the bitfile and run the simulations:

- yosys
- nextpnr-ice40
- icepack
- icarus verilog


## Usage

Simulate it with `make tb_alpacacorn_soc.vcd` and investigate the trace with `gtkwave tb_alpacacorn_soc.vcd`.
Just running `make` creates a bit file which can be programmed on the FPGA.
Check the Makefile for intermediate and additional receipes,
or if you want to synthesize for another FPGA model, package, or board.

Running the demo on a board might require additional circuitry if it lacks a button.
![Demo of SoC running heart beat monitor application](doc/img/demo.gif)

If you want to know more about the design, have a look at the documentation in folder `doc/`.

Have fun!


## Contributing

Please contact the authors first if you plan to contribute.


## License

This is [Open Source Hardware](http://freedomdefined.org/OSHW),
for details check the [license](LICENSE).
