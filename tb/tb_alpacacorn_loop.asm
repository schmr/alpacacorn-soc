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
