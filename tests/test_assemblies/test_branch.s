loadi r1 3
loadi r2 1

loop:
    sub r1 r2
    mv r0 r1

    add r3 r2
    mv r0 r3

    bne r1 loop