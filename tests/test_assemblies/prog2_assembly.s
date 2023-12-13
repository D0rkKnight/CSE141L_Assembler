# store loop counter in r6 and initialize loop counter = 0
loadi r1 0
mv r1 r6               # r6 = 0

# store index counter in r7 and initialize index counter = 0
loadi r1 0
mv r1 r7               # r7 = 0

Loop:                  # recalculate parity bits and xor each with original ones
    # recalculate p8 =  ^(b11:b5)
    loadi r1 1         # r1 = 1
    lshift r1 5        # r1 = 32
    loadi r2 1         # r2 = 1
    sub r1 r2          # r0 = 32-1 = 31
    add r0 r7          # r0 = 31 + index counter
    load r2 r0         # r2 = mem[31 + index counter] = b11:b5,p8
    rshift r2 1        # r2 = 0_b11:b5
    parity r2 r1       # r1 = p8rec

    # get input p8
    load r2 r0         # r2 = mem[31 + index counter] = b11:b5,p8
    lshift r2 7        # r2 = p8_0000000
    rshift r2 7        # r2 = p8

    # xor p8rec with p8 to see if p8rec and p8 is different (1: !=, 0: ==)
    xor r1 r2          # r0 = p8rec xor p8

    # store the result in mem[64]
    loadi r1 1
    lshift r1 6        # r1 = 64
    store r0 r1        # mem[64] = p8rec xor p8

    # recalculate p4 = ^(b11:b8,b4,b3,b2)
    loadi r1 1         # r1 = 1
    lshift r1 5        # r1 = 32
    loadi r2 1         # r2 = 1
    sub r1 r2          # r0 = 32-1 = 31
    add r0 r7          # r0 = 31 + index counter
    load r2 r0         # r2 = mem[31 + index counter] = b11:b5,p8
    rshift r2 4        # r2 = 0000_b11:b8
    rshift r2 4        # r2 = b11:b8_0000

    loadi r1 2         # r1 = 2
    sub r0 r1          # r0 = 30 + index counter
    load r3 r0         # r3 = mem[30 + index counter] = b4:b2,p4,b1,p2,p1,p0
    rshift r3 5        # r3 = 00000_b4:b2
    lshift r3 1        # r3 = 0000_b4:b2_0
    or r2 r3           # r0 = b11:b8,b4,b3,b2_0

    parity r0 r1       # r1 = p4rec

    # get input p4
    loadi r0 1
    lshift r0 5        # r0 = 32
    loadi r2 2         # r2 = 2
    sub r0 r2          # r0 = 32-2 = 30
    add r0 r7          # r0 = 30 + index counter
    load r2 r0         # r2 = mem[30 + index counter] = b4:b2,p4,b1,p2,p1,p0
    lshift r2 3        # r2 = p4,b1,p2,p1,p0_000
    rshift r2 7        # r2 = p4

    # xor p4rec with p4 to see if p4rec and p4 is different
    xor r1 r2          # r0 = p4rec xor p4
    mv r0 r1           # r1 = p4rec xor p4

    # store the result in mem[65]
    loadi r2 1
    lshift r2 6        # r2 = 64
    loadi r3 1         # r3 = 1
    add r2 r3          # r0 = 65
    store r1 r0        # mem[65] = p4rec xor p4

    # recalculate p2 = ^(b11,b10,b7,b6,b4,b3,b1)
    loadi r1 1         # r1 = 1
    lshift r1 5        # r1 = 32
    loadi r2 1         # r2 = 1
    sub r1 r2          # r0 = 32-1 = 31
    add r0 r7          # r0 = 31 + index counter
    load r2 r0         # r2 = mem[31 + index counter] = b11:b5,p8
    rshift r2 6        # r2 = 000000_b11,b10
    lshift r2 6        # r2 = b11,b10_000000

    load r3 r0         # r3 = mem[31 + index counter] = b11:b5,p8
    rshift r3 4        # r3 = b7:b5,p8_0000
    lshift r3 6        # r3 = 000000_b7,b6
    rshift r3 4        # r3 = 00_b7,b6_0000
    or r2 r3           # r0 = b11,b10,b7,b6_0000
    mv r0 r3           # r3 = b11,b10,b7,b6_0000

    loadi r0 1
    lshift r0 5        # r0 = 32
    loadi r1 2         # r1 = 2
    sub r0 r1          # r0 = 30-2 = 30
    add r0 r7          # r0 = 30 + index counter
    load r2 r0         # r2 = mem[30 + index counter] = b4:b2,p4,b1,p2,p1,p0
    rshift r2 6        # r2 = 000000_b4,b3
    lshift r2 2        # r2 = 0000_b4,b3_00
    or r2 r3           # r0 = b11,b10,b7,b6,b4,b3_00
    mv r0 r3           # r3 = b11,b10,b7,b6,b4,b3_00

    loadi r0 1
    lshift r0 5        # r0 = 32
    loadi r1 2         # r1 = 2
    sub r0 r1          # r0 = 30-2 = 30
    add r0 r7          # r0 = 30 + index counter
    load r2 r0         # r2 = mem[30 + index counter] = b4:b2,p4,b1,p2,p1,p0
    lshift r2 4        # r2 = b1,p2,p1,p0_0000
    rshift r2 7        # r2 = 0000000_b1
    lshift r2 1        # r2 = 000000_b1_0
    or r2 r3           # r0 = b11,b10,b7,b6,b4,b3,b1_0

    parity r0 r3       # r3 = p2rec

    # get input p2
    loadi r0 1
    lshift r0 5        # r0 = 32
    loadi r1 2         # r1 = 2
    sub r0 r1          # r0 = 30-2 = 30
    add r0 r7          # r0 = 30 + index counter
    load r2 r0         # r2 = mem[30 + index counter] = b4:b2,p4,b1,p2,p1,p0
    lshift r2 5        # r2 = p2,p1,p0_00000
    rshift r2 7        # r2 = p2

    # xor p2rec with p2 to see if p2rec and p2 is different
    xor r2 r3          # r0 = p2rec xor p2
    mv r0 r3           # r3 = p2rec xor p2

    # store the result in mem[66]
    loadi r0 1
    lshift r0 6        # r0 = 64
    loadi r1 2         # r1 = 2
    add r0 r1          # r0 = 66
    store r3 r0        # mem[66] = p2rec xor p2

    # recalculate p1 = ^(b11,b9,b7,b5,b4,b2,b1)
    loadi r1 1         # r1 = 1
    lshift r1 5        # r1 = 32
    loadi r2 1         # r2 = 1
    sub r1 r2          # r0 = 32-1 = 31
    add r0 r7          # r0 = 31 + index counter
    load r2 r0         # r2 = mem[31 + index counter] = b11:b5,p8
    rshift r2 7        # r2 = 0000000_b11
    lshift r2 7        # r2 = b11_0000000

    load r3 r0         # r3 = mem[31 + index counter] = b11:b5,p8
    lshift r3 2        # r3 = b9:b5,p8_00
    rshift r3 7        # r3 = 0000000_b9
    lshift r3 6        # r3 = 0_b9_000000
    or r2 r3           # r0 = b11,b9_000000
    mv r0 r3           # r3 = b11,b9_000000

    loadi r1 1         # r1 = 1
    lshift r1 5        # r1 = 32
    loadi r2 1         # r2 = 1
    sub r1 r2          # r0 = 32-1 = 31
    add r0 r7          # r0 = 31 + index counter
    load r2 r0         # r2 = mem[31 + index counter] = b11:b5,p8
    lshift r2 4        # r2 = b7:b5,p8_0000
    rshift r2 7        # r2 = 0000000_b7
    lshift r2 5        # r2 = 00_b7_00000
    or r2 r3           # r0 = b11,b9,b7_00000
    mv r0 r3           # r3 = b11,b9,b7_00000

    loadi r1 1         # r1 = 1
    lshift r1 5        # r1 = 32
    loadi r2 1         # r2 = 1
    sub r1 r2          # r0 = 32-1 = 31
    add r0 r7          # r0 = 31 + index counter
    load r2 r0         # r2 = mem[31 + index counter] = b11:b5,p8
    rshift r2 1        # r2 = 0_b11:b5
    lshift r2 7        # r2 = b5_0000000
    rshift r2 3        # r2 = 000_b5_0000
    or r2 r3           # r0 = b11,b9,b7,b5_0000
    mv r0 r3           # r3 = b11,b9,b7,b5_0000

    loadi r0 1
    lshift r0 5        # r0 = 32
    loadi r1 2         # r1 = 2
    sub r0 r1          # r0 = 30-2 = 30
    add r0 r7          # r0 = 30 + index counter
    load r2 r0         # r2 = mem[30 + index counter] = b4:b2,p4,b1,p2,p1,p0
    rshift r2 7        # r2 = 0000000_b4
    lshift r2 3        # r2 = 0000_b4_000
    or r2 r3           # r0 = b11,b9,b7,b5,b4_000
    mv r0 r3           # r3 = b11,b9,b7,b5,b4_000

    loadi r0 1
    lshift r0 5        # r0 = 32
    loadi r1 2         # r1 = 2
    sub r0 r1          # r0 = 30-2 = 30
    add r0 r7          # r0 = 30 + index counter
    load r2 r0         # r2 = mem[30 + index counter] = b4:b2,p4,b1,p2,p1,p0
    lshift r2 2        # r2 = b2,p4,b1,p2,p1,p0_00
    rshift r2 7        # r2 = 0000000_b2
    lshift r2 2        # r2 = 00000_b2_00
    or r2 r3           # r0 = b11,b9,b7,b5,b4,b2_00
    mv r0 r3           # r3 = b11,b9,b7,b5,b4,b2_00

    loadi r0 1
    lshift r0 5        # r0 = 32
    loadi r1 2         # r1 = 2
    sub r0 r1          # r0 = 30-2 = 30
    add r0 r7          # r0 = 30 + index counter
    load r2 r0         # r2 = mem[30 + index counter] = b4:b2,p4,b1,p2,p1,p0
    lshift r2 4        # r2 = b1,p2,p1,p0_0000
    rshift r2 7        # r2 = 0000000_b1
    lshift r2 1        # r2 = 000000_b1_0
    or r2 r3           # r0 = b11,b9,b7,b5,b4,b2,b1_0

    parity r0 r3       # r3 = p1rec

    # get input p1
    loadi r0 1
    lshift r0 5        # r0 = 32
    loadi r1 2         # r1 = 2
    sub r0 r1          # r0 = 30-2 = 30
    add r0 r7          # r0 = 30 + index counter
    load r2 r0         # r2 = mem[30 + index counter] = b4:b2,p4,b1,p2,p1,p0
    lshift r2 6        # r2 = p1,p0_000000
    rshift r2 7        # r2 = p1

    # xor p1rec with p1 to see if p1rec and p1 is different
    xor r2 r3          # r0 = p1rec xor p1
    mv r0 r3           # r3 = p1rec xor p1

    # store the result in mem[67]
    loadi r0 1
    lshift r0 6        # r0 = 64
    loadi r1 3         # r1 = 3
    add r0 r1          # r0 = 67
    store r3 r0        # mem[67] = p1rec xor p1

    # recalculate p0 = ^(b11:1,p8rec,p4rec,p2rec,p1rec)
    loadi r1 1         # r1 = 1
    lshift r1 5        # r1 = 32
    loadi r2 1         # r2 = 1
    sub r1 r2          # r0 = 32-1 = 31
    add r0 r7          # r0 = 31 + index counter
    load r2 r0         # r2 = mem[31 + index counter] = b11:b5,p8
    parity r2 r3       # r3 = ^(b11:b5)

    loadi r0 1
    lshift r0 5        # r0 = 32
    loadi r1 2         # r1 = 2
    sub r0 r1          # r0 = 30-2 = 30
    add r0 r7          # r0 = 30 + index counter
    load r2 r0         # r2 = mem[30 + index counter] = b4:b2,p4,b1,p2,p1,p0
    rshift r2 5        # r2 = 00000_b4:b2
    parity r2 r1       # r1 = ^(b4:b2)

    xor r1 r3          # r0 = ^(b11:b2)
    mv r0 r3           # r3 = ^(b11:b2)

    loadi r0 1
    lshift r0 5        # r0 = 32
    loadi r1 2         # r1 = 2
    sub r0 r1          # r0 = 30-2 = 30
    add r0 r7          # r0 = 30 + index counter
    load r2 r0         # r2 = mem[30 + index counter] = b4:b2,p4,b1,p2,p1,p0
    lshift r2 4        # r2 = b1,p2,p1,p0_0000
    rshift r2 7        # r2 = 0000000_b1

    xor r2 r3          # r0 = ^(b11:b1)
    mv r0 r3           # r3 = ^(b11:b1)

    loadi r1 1
    lshift r1 6        # r1 = 64
    load r2 r1         # r2 = p8rec

    xor r2 r3          # r0 = ^(b11:b1,p8rec)
    mv r0 r3           # r3 = ^(b11:b1,p8rec)

    loadi r0 1
    lshift r0 6        # r0 = 64
    loadi r1 1         # r1 = 1
    add r0 r1          # r0 = 65
    load r2 r0         # r2 = mem[65] = p4rec

    xor r2 r3          # r0 = ^(b11:b1,p8rec,p4rec)
    mv r0 r3           # r3 = ^(b11:b1,p8rec,p4rec)

    loadi r0 1
    lshift r0 6        # r0 = 64
    loadi r1 2         # r1 = 2
    add r0 r1          # r0 = 66
    load r2 r0         # r2 = mem[66] = p2rec

    xor r2 r3          # r0 = ^(b11:b1,p8rec,p4rec,p2rec)
    mv r0 r3           # r3 = ^(b11:b1,p8rec,p4rec,p2rec)

    loadi r0 1
    lshift r0 6        # r0 = 64
    loadi r1 3         # r1 = 3
    add r0 r1          # r0 = 67
    load r2 r0         # r2 = mem[67] = p4rec

    xor r2 r3          # r0 = ^(b11:b1,p8rec,p4rec,p2rec,p1rec) = p0rec
    mv r0 r3           # r3 = p0rec

    # get input p0
    loadi r0 1
    lshift r0 5        # r0 = 32
    loadi r1 2         # r1 = 2
    sub r0 r1          # r0 = 30-2 = 30
    add r0 r7          # r0 = 30 + index counter
    load r2 r0         # r2 = mem[30 + index counter] = b4:b2,p4,b1,p2,p1,p0
    lshift r2 7        # r2 = p0_0000000
    rshift r2 7        # r2 = p0

    # xor p1rec with p1 to see if p1rec and p1 is different
    xor r2 r3          # r0 = p0rec xor p0
    mv r0 r3           # r3 = p0rec xor p0

    # store the result in mem[68]
    loadi r0 1
    lshift r0 6        # r0 = 64
    loadi r1 4         # r1 = 4
    add r0 r1          # r0 = 68
    store r3 r0        # mem[68] = p0rec xor p0


Num_of_Errors:
    # if p0rec xor p0 != 0, one error
    loadi r0 1
    lshift r0 6        # r0 = 64
    loadi r1 4         # r1 = 4
    add r0 r1          # r0 = 68
    load r3 r0         # r3 = mem[68] = p0rec xor p0
    mv r3 r0           # r0 = p0rec xor p0
    bne One_Error      # brach to One_Errors if p0rec xor p0 != 0

    # elif any other parity != 0, 2 errors
    loadi r1 1
    lshift r1 6        # r1 = 64
    load r3 r1         # r3 = mem[64] = p8rec xor p8
    mv r3 r0           # r0 = p8rec xor p8
    bne Two_Errors     # branch to Two_Errors if p8rec xor p8 != 0

    loadi r1 1
    lshift r1 6        # r1 = 64
    loadi r2 1         # r2 = 1
    add r1 r2          # r0 = 65
    load r3 r0         # r3 = mem[65] = p4rec xor p4
    mv r3 r0           # r0 = p4rec xor p4
    bne Two_Errors     # branch to Two_Errors if p4rec xor p4 != 0

    loadi r1 1
    lshift r1 6        # r1 = 64
    loadi r2 2         # r2 = 2
    add r1 r2          # r0 = 66
    load r3 r0         # r3 = mem[66] = p2rec xor p2
    mv r3 r0           # r0 = p2rec xor p2
    bne Two_Errors     # branch to Two_Errors if p2rec xor p2 != 0

    loadi r1 1
    lshift r1 6        # r1 = 64
    loadi r2 3         # r2 = 3
    add r1 r2          # r0 = 67
    load r3 r0         # r3 = mem[67] = p1rec xor p1
    mv r3 r0           # r0 = p1rec xor p1
    bne Two_Errors     # branch to Two_Errors if p1rec xor p1 != 0

    # otherwise, no error
    loadi r0 1
    bne No_Error    # branch to No_Error otherwise
    

One_Error:
    # put 4 xored parity bits in a byte
    loadi r0 1         # r0 = 1
    lshift r0 6        # r0 = 64
    load r3 r0         # r0 = mem[64] = p8xored
    lshift r3 3        # r3 = 0000_p8xored_000

    loadi r0 1
    lshift r0 6        # r0 = 64
    loadi r1 1         # r1 = 1
    add r0 r1          # r0 = 65
    load r2 r0         # r2 = mem[65] = p4xored
    lshift r2 2        # r2 = 00000_p4xored_00

    or r2 r3           # r0 = 0000_p8x,p4x_00
    mv r0 r3           # r3 = 0000_p8x,p4x_00

    loadi r0 1
    lshift r0 6        # r0 = 64
    loadi r1 2         # r1 = 2
    add r0 r1          # r0 = 66
    load r2 r0         # r2 = mem[66] = p2xored
    lshift r2 1        # r2 = 000000_p2xored_0

    or r2 r3           # r0 = 0000_p8x,p4x,p2x_0
    mv r0 r3           # r3 = 0000_p8x,p4x,p2x_0

    loadi r0 1
    lshift r0 6        # r0 = 64
    loadi r1 3         # r1 = 3
    add r0 r1          # r0 = 67
    load r2 r0         # r2 = mem[67] = p1xored
    lshift r2 2        # r2 = 0000000_p1xored

    or r2 r3           # r0 = 0000_p8x,p4x,p2x,p1x
    mv r0 r3           # r3 = 0000_p8x,p4x,p2x,p1x

LSW_case:
    # if p8x == 1, the wrong bit is in MSW
    loadi r1 1
    lshift r1 6        # r1 = 64
    load r2 r1         # r2 = mem[64] = p8x
    mv r2 r0           # r0 = p8x
    bne MSW_case       # branch to MSW_case

    # get output LSW
    loadi r0 1
    lshift r0 5        # r0 = 32
    loadi r1 2         # r1 = 2
    sub r0 r1          # r0 = 30-2 = 30
    add r0 r7          # r0 = 30 + index counter
    load r2 r0         # r2 = mem[30 + index counter] = b4:b2,p4,b1,p2,p1,p0

    # generate mask
    loadi r1 1         # r1 = 1
    lsr r1 r3          # lshift r1 by r3 => r0 = mask

    # flip the wrong bit by xor mask with LSW
    xor r0 r2          # r0 = fixed output LSW
    mv r0 r2           # r2 = fixed output LSW

    # store it back
    loadi r0 1
    lshift r0 5        # r0 = 32
    loadi r1 2         # r1 = 2
    sub r0 r1          # r0 = 30-2 = 30
    add r0 r7          # r0 = 30 + index counter
    store r2 r0        # mem[30 + index counter] = fixed output LSW

    bne Recover        # branch to recover

MSW_case:
    lshift r3 5        # r3 = p4x,p2x,p1x_00000
    rshift r3 5        # r3 = 00000_p4x,p2x,p1x
    
    # get output MSW
    loadi r1 1         # r1 = 1
    lshift r1 5        # r1 = 32
    loadi r2 1         # r2 = 1
    sub r1 r2          # r0 = 32-1 = 31
    add r0 r7          # r0 = 31 + index counter
    load r2 r0         # r2 = mem[31 + index counter] = b11:b5,p8

    # generate mask
    loadi r1 1         # r1 = 1
    lsr r1 r3          # lshift r1 by r3 => r0 = mask

    # flip the wrong bit by xor mask with MSW
    xor r0 r2          # r0 = fixed output MSW
    mv r0 r2           # r2 = fixed output MSW

    # store it back
    loadi r0 1
    lshift r0 5        # r0 = 32
    loadi r1 1         # r1 = 1
    sub r0 r1          # r0 = 30-1 = 31
    add r0 r7          # r0 = 31 + index counter
    store r2 r0        # mem[31 + index counter] = fixed output MSW

    bne Recover     # branch to recover

Recover:
    # recover MSW
    loadi r1 1         # r1 = 1
    lshift r1 5        # r1 = 32
    loadi r2 1         # r2 = 1
    sub r1 r2          # r0 = 32-1 = 31
    add r0 r7          # r0 = 31 + index counter
    load r2 r0         # r2 = mem[31 + index counter] = b11:b5,p8
    rshift r2 5        # r2 = 00000_b11:b9
    loadi r1 1         # r1 = 1
    lshift r1 6        # r1 = 0100_0000
    or r1 r2           # r0 = 01000_b11:b9
    mv r0 r3           # r3 = 01000_b11:b9

    loadi r1 1         # r1 = 1
    add r1 r7          # r0 = 1 + index counter
    store r3 r0        # mem[1 + index counter] = 01000_b11:b9

    # recover LSW
    loadi r1 1         # r1 = 1
    lshift r1 5        # r1 = 32
    loadi r2 1         # r2 = 1
    sub r1 r2          # r0 = 32-1 = 31
    add r0 r7          # r0 = 31 + index counter
    load r2 r0         # r2 = mem[31 + index counter] = b11:b5,p8
    rshift r2 1        # r2 = 0_b11:b5
    lshift r2 5        # r2 = b8:b5_0000
    mv r2 r3           # r3 = b8:b5_0000

    loadi r0 1
    lshift r0 5        # r0 = 32
    loadi r1 2         # r1 = 2
    sub r0 r1          # r0 = 30-2 = 30
    add r0 r7          # r0 = 30 + index counter
    load r2 r0         # r2 = mem[30 + index counter] = b4:b2,p4,b1,p2,p1,p0
    rshift r2 5        # r2 = 00000_b4:b2
    lshift r2 1        # r2 = 0000_b4:b2_0
    or r2 r3           # r0 = b8:b2_0
    mv r0 r3           # r3 = b8:b2_0

    loadi r0 1
    lshift r0 5        # r0 = 32
    loadi r1 2         # r1 = 2
    sub r0 r1          # r0 = 30-2 = 30
    add r0 r7          # r0 = 30 + index counter
    load r2 r0         # r2 = mem[30 + index counter] = b4:b2,p4,b1,p2,p1,p0
    lshift r2 4        # r2 = b1,p2,p1,p0_0000
    rshift r2 7        # r2 = 0000000_b1
    or r2 r3           # r0 = b8:b1
    
    store r0 r7        # mem[index counter] = b8:b1
    
    loadi r0 1
    bne Update_Loop


Two_Errors:
    loadi r1 1         # r1 = 1
    lshift r1 7        # r1 = 1000_0000
    store r1 r7        # mem[index counter] = 1000_0000
    loadi r2 1
    add r2 r7          # r0 = 1 + index counter
    store r1 r0        # mem[1 + index counter] = 1000_0000

    bne Update_Loop


No_Error:
    # recover MSW
    loadi r1 1         # r1 = 1
    lshift r1 5        # r1 = 32
    loadi r2 1         # r2 = 1
    sub r1 r2          # r0 = 32-1 = 31
    add r0 r7          # r0 = 31 + index counter
    load r2 r0         # r2 = mem[31 + index counter] = b11:b5,p8
    rshift r2 5        # r2 = 00000_b11:b9

    loadi r1 1         # r1 = 1
    add r1 r7          # r0 = 1 + index counter
    store r3 r0        # mem[1 + index counter] = 00000_b11:b9

    # recover LSW
    loadi r1 1         # r1 = 1
    lshift r1 5        # r1 = 32
    loadi r2 1         # r2 = 1
    sub r1 r2          # r0 = 32-1 = 31
    add r0 r7          # r0 = 31 + index counter
    load r2 r0         # r2 = mem[31 + index counter] = b11:b5,p8
    rshift r2 1        # r2 = 0_b11:b5
    lshift r2 5        # r2 = b8:b5_0000
    mv r2 r3           # r3 = b8:b5_0000

    loadi r0 1
    lshift r0 5        # r0 = 32
    loadi r1 2         # r1 = 2
    sub r0 r1          # r0 = 30-2 = 30
    add r0 r7          # r0 = 30 + index counter
    load r2 r0         # r2 = mem[30 + index counter] = b4:b2,p4,b1,p2,p1,p0
    rshift r2 5        # r2 = 00000_b4:b2
    lshift r2 1        # r2 = 0000_b4:b2_0
    or r2 r3           # r0 = b8:b2_0
    mv r0 r3           # r3 = b8:b2_0

    loadi r0 1
    lshift r0 5        # r0 = 32
    loadi r1 2         # r1 = 2
    sub r0 r1          # r0 = 30-2 = 30
    add r0 r7          # r0 = 30 + index counter
    load r2 r0         # r2 = mem[30 + index counter] = b4:b2,p4,b1,p2,p1,p0
    lshift r2 4        # r2 = b1,p2,p1,p0_0000
    rshift r2 7        # r2 = 0000000_b1
    or r2 r3           # r0 = b8:b1
    
    store r0 r7        # mem[index counter] = b8:b1


Update_Loop:
    # update index counter
    loadi r1 2         # r1 = 2
    add r1 r7          # r0 = index counter + 2
    mv r0 r7           # r7 = index counter + 2

    # update loop counter
    loadi r1 1         # r1 = 1
    add r1 r6          # r0 = loop counter + 1
    mv r0 r6           # r6 = loop counter + 1

    # branch to Loop
    loadi r1 7
    sub r0 r1          # r0 = loop counter - 7
    sub r0 r1          # r0 = loop counter - 7

    loadi r1 1
    sub r0 r1           # check if loop counter = 0
    bne Loop

Halt:
    halt