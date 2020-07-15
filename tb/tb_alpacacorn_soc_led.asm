# Example program running a loop of 127 iterations,
# followed by triggering a write to the highest memory address.
# At the highest memory address writes are detected by hardware
# and counted. The counter is used to switch a LED.

# ADR   LABEL       CODE           COMMENT     BIN                HEX


                    # Carry is clear by reset.
00                  JCC loop                   11_00_0101         C5

01      inc:        db 1                        0000_0001         01
02      limit:      db -127                     1000_0001         81
03      i:          db 0                        0000_0000         00
04      minusone:   db -1                       1111_1111         FF

        loop:       # empty loop body
                    # i++
                    # LOD i, ADD inc
05                  NOR minusone   # CLR       00_00_0100         04
06                  ADD i                      01_00_0011         43
07                  ADD inc                    01_00_0001         41
08                  STO i                      10_00_0011         83

                    # i < 10?
09                  ADD limit                  01_00_0010         42
10                  JCC loop                   11_00_0101         C5

                    # Write something to last address
11                  STO <63>                   10_11_1111         BF

                    # Reset program
12                  NOR minusone               00_00_0100         04
13                  STO i                      10_00_0011         83

14      end:        JCC loop        # JMP loop  11_00_0101         C5
15                  JCC loop                    11_00_0101         C5

16      never:      ADD inc                    01_00_0001         41
