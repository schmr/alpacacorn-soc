# alpacacore-soc documentation

## Overview
The SoC consists of the alpacacore CPU and a counter which records the write accesses to a specific memory location.
These memory writes are made visible on a LED, serving as a heartbeat that the CPU executes the program correctly.

## Additional circuitry
To reset the system, additional circuitry is required as shown:

![Demo of alpacacore-soc on iceHX8K demo board](img/demo.gif)

![Circuit diagram sketch of reset button](img/pull_up_rst_n_i.png)

## The CPU core
The CPU is rather simple, the following images present the data path and control.
The ISA is [documented separately](isa.md).

![Data path of CPU](img/cpu.png)

![Control state machine of CPU](img/statemachine.png)

