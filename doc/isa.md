# Alpacacorn instruction set architecture


## Registers

### Akkumulator register `a_reg`

### Memory access register `mar_reg`

### Program counter register `pc_reg`

### Carry bit register `carry_reg`

### Data register `d_reg`
Stores 8 Bit of data read from SRAM.


## Memory model
Program and data share same flat address space.
Currently 2^6=64 different addresses are differentiable.
Each address stores a 8 Bit word.
In the simplest case, a 64 Byte SRAM occupies the whole address space,
but it might as well be possible to have other hardware use parts
of the address space.


## Native instructions

### ADD <adr>
Add content of memory address to accumulator register.
Add `d_reg` content to `a_reg`, where `d_reg` is loaded with the data
from the address specified with the opcode.

### NOR <adr>
Logical NOR content of `a_reg` with `d_reg`,
where `d_reg` is loaded with the data from the address specified with the opcode.

### STA (store accumulator)
Store content of `a_reg` to address in `mar_reg`.

### JCC (jump carry clear)
Jump to absolute address stored in lower part of `d_reg` if the carry bit in `carry_reg` is **not** set, *and clear the carry bit!*


## Synthesized instructions

These instructions are synthesized from a sequence of native instructions.
They describe commonly needed instructions, and could be implemented
using a macro assembler.

### CLR (clear accumulator)
NOR where `d_reg` lower part is all ones.

### INV (invert accumulator)
NOR where `d_reg` lower part is all zeros.

### NEG (negate, switch sign)
INV `a_reg` content and add 1

### LOD (load data)
CLR `a_reg` followed by ADD.

### JMP (jump unconditionally)
JCC adr followed by JCC adr


## Possible future extensions

### Differentiate more instructions
The STA instructions has no argument/address because it directly works with the MAR register.
I could differentiate more instructions by using these unused bits.
Then I would have two classes of instructions,
one which use the 6 Bits after the opcode to specify an address,
and one where I can use the 6 Bits to encode additional information.

### MAR only addressing
Let all instructions use the MAR,
have one instructions to load MAR with a literal address

### Relative addressing
Let instruction addresses be relative to the PC and MAR registers.


### Adding a data and return stack to better support calling functions
Seems not necessary given the limited program memory.
Moreover, the overhead is not a good fit for such a minimal machine.
Better have a dedicated stack machine :-)
