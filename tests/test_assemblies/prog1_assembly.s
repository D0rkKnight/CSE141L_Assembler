
#   mem[64] = p8, mem[65] = p4, mem[66] = p2, mem[67] = p1, mem[68] = p0,
#   r6 = loop counter,
#   r7 = index counter


# store loop counter in r6 and initialize loop counter = 0
loadi r1 0
mv r1 r6               # r6 = 0

# store index counter in r7 and initialize index counter = 0
loadi r1 0
mv r1 r7               # r7 = 0

Loop:
    # calculate p8 = ^(b11:b5)
    loadi r1 1         # r1 = 1
    add r1 r7          # r0 = 1 + index counter
    load r2 r0         # r2 = mem[1 + index counter] = 00000_b11:b9
    lshift r2 5        # r2 = b11:b9_00000
    
    loadi r0 0         # r0 = 0
    add r0 r7          # r0 = index counter
    load r3 r0         # r3 = mem[index counter] = b8:b1
    rshift r3 4        # r3 = 0000_b8:b5
    lshift r3 1        # r3 = 000_b8:b5_0
    
    or r2 r3           # r0 = b11:5_0
    parity r0 r1       # r1 = p8

    # store p8 in mem[64]
    loadi r2 1
    lshift r2 6        # r2 = 64
    store r1 r2        # mem[64] = p8

    # store output MSW in mem[31 + index counter]
    or r0 r1           # r0 = b11:5_p8
    mv r0 r1           # r1 = r0 = b11:5_p8
    loadi r2 1         
    lshift r2 5        # r2=32
    loadi r3 1
    sub r2 r3          # r0=32-1=31
    add r0 r7          # r0 = 31 + index counter
    store r1 r0        # mem[31 + index counter] = b11:5_p8

    # calculate p4 = ^(b11:b8,b4,b3,b2)
    loadi r1 1         # r1 = 1
    add r1 r7          # r0 = 1 + index counter
    load r2 r0         # r2 = 00000_b11:b9
    lshift r2 5        # r2 = b11:b9_00000
    
    loadi r0 0         # r0 = 0
    add r0 r7          # r0 = index counter
    load r3 r0         # r3 = b8:b1
    lshift r3 7        # r3 = 0000000_b8
    rshift r3 4        # r3 = 000_b8_0000
    
    or r2 r3           # r0 = b11:b8_0000
    mv r0 r4           # r4 = r0 = b11:b8_0000

    loadi r0 0
    add r0 r7          # r0 = index counter
    load r3 r0         # r3 = b8:b1
    lshift r3 4        # r3 = b4:b1_0000
    rshift r3 5        # r3 = 00000_b4:b2
    lshift r3 1        # r3 = 0000_b4:b2_0
    
    or r3 r4           # r0 = b11:b8,b4,b3,b2_0
    parity r0 r1       # r1 = 0000000_p4

    # store p4 in mem[65]
    loadi r2 1
    lshift r2 6        # r2 = 64
    loadi r3 1
    add r2 r3          # r0 = 65
    store r1 r0        # mem[65] = p4

    # calculate p2 = ^(b11,b10,b7,b6,b4,b3,b1))
        
    loadi r1 1         # r1 = 1
    add r1 r7          # r0 = 1 + index counter
    load r2 r0         # r2 = mem[1 + index counter] = 00000_b11:b9
    rshift r2 1        # r2 = 000000_b11:b10
    lshift r2 6        # r2 = b11:b10_000000
    
    loadi r0 0         # r0 = 0
    add r0 r7          # r0 = index counter
    load r3 r0         # r3 = mem[index counter] = b8:b1
    lshift r3 1        # r3 = b7:b1_0
    rshift r3 6        # r3 = 000000_b7:b6
    lshift r3 4        # r3 = 00_b7:b6_0000
    
    or r2 r3           # r0 = b11,b10,b7,b6_0000
    mv r0 r2           # r2 = b11,b10,b7,b6_0000

    loadi r0 0         # r0 = 0
    add r0 r7          # r0 = index counter
    load r3 r0         # r3 = mem[index counter] = b8:b1
    lshift r3 4        # r3 = b4:b1_0000
    rshift r3 6        # r3 = 000000_b4:b3
    lshift r3 2        # r3 = 0000_b4:b3_00
    
    or r2 r3           # r0 = b11,b10,b7,b6,b4,b3_00
    mv r0 r2           # r2 = b11,b10,b7,b6,b4,b3_00

    loadi r0 0         # r0 = 0
    add r0 r7          # r0 = index counter
    load r3 r0         # r3 = mem[index counter] = b8:b1
    lshift r3 7        # r3 = b1_0000000
    rshift r3 6        # r3 = 000000_b1_0
    
    or r2 r3           # r0 = b11,b10,b7,b6,b4,b3,b1_0
    parity r0 r1       # r1 = p2

    # store p2 in mem[66]
    loadi r2 1
    lshift r2 6        # r2 = 64
    loadi r3 2
    add r2 r3          # r0 = 66
    store r1 r0        # mem[66] = p2

    # calculate p1 = ^(b11,b9,b7,b5,b4,b2,b1)
    loadi r1 1         # r1 = 1
    add r1 r7          # r0 = 1 + index counter
    load r2 r0         # r2 = mem[1 + index counter] = 00000_b11:b9
    rshift r2 2        # r2 = 0000000_b11
    lshift r2 7        # r2 = b11_0000000

    load r3 r0         # r3 = 00000_b11:b9
    lshift r3 7        # r3 = b9_0000000
    rshift r3 1        # r3 = 0_b9_000000
    
    or r2 r3           # r0 = b11,b9_000000
    mv r0 r2           # r2 = b11,b9_000000

    loadi r0 0         # r0 = 0
    add r0 r7          # r0 = index counter
    load r3 r0         # r3 = b8:b1
    lshift r3 1        # r3 = b7:b1_0
    rshift r3 7        # r3 = 0000000_b7
    lshift r3 5        # r3 = 00_b7_00000
    
    or r2 r3           # r0 = b11,b9,b7_00000
    mv r0 r2           # r2 = b11,b9,b7_00000

    loadi r0 0         # r0 = 0
    add r0 r7          # r0 = index counter
    load r3 r0         # r3 = b8:b1
    lshift r3 3        # r3 = b5:b1_000
    rshift r3 6        # r3 = 000000_b5:b4
    lshift r3 3        # r3 = 000_b5:b4_000
    
    or r2 r3           # r0 = b11,b9,b7,b5,b4_000
    mv r0 r2           # r2 = b11,b9,b7,b5,b4_000

    loadi r0 0         # r0 = 0
    add r0 r7          # r0 = index counter
    load r3 r0         # r3 = b8:b1
    lshift r3 6        # r3 = b2:b1_000000
    rshift r3 5        # r3 = 00000_b2:b1_0
    
    or r2 r3           # r0 = b11,b9,b7,b5,b4,b2,b1_0
    parity r0 r1       # r1 = p1

    # store p1 in mem[67]
    loadi r2 1
    lshift r2 6        # r2 = 64
    loadi r3 3
    add r2 r3          # r0 = 67
    store r1 r0        # mem[67] = p1

    # calculate p0 = ^(b11:1,p8,p4,p2,p1) 
    loadi r1 1         # r1 = 1
    add r1 r7          # r0 = 1 + index counter
    load r2 r0         # r2 = mem[1 + index counter] = 00000_b11:b9
    parity r2 r1       # r1 = ^(b11:b9)
    
    loadi r0 0         # r0 = 0
    add r0 r7          # r0 = index counter
    load r3 r0         # r3 = mem[index counter] = b8:b1    
    parity r3 r0       # r0 = ^(b8:b1)

    xor r0 r1          # r0 = ^(b11:b1)

    loadi r2 1
    lshift r2 6        # r2 = 64
    load r1 r2         # r1 = mem[64] = p8
    xor r0 r1          # r0 = ^(b11:b1,p8)
    mv r0 r4           # r4 = ^(b11:b1,p8)

    loadi r2 1
    lshift r2 6        # r2 = 64
    loadi r3 1
    add r2 r3          # r0 = 65
    load r1 r0         # r1 = mem[65] = p4
    xor r0 r4          # r0 = ^(b11:1,p8,p4)
    mv r0 r4           # r4 = ^(b11:1,p8,p4)

    loadi r2 1
    lshift r2 6        # r2 = 64
    loadi r3 2
    add r2 r3          # r0 = 66
    load r1 r0         # r1 = mem[66] = p2
    xor r0 r4          # r0 = ^(b11:1,p8,p4,p2)
    mv r0 r4           # r4 = ^(b11:1,p8,p4,p2)

    loadi r2 1
    lshift r2 6        # r2 = 64
    loadi r3 3
    add r2 r3          # r0 = 67
    load r1 r0         # r1 = mem[67] = p1
    xor r0 r4          # r0 = ^(b11:1,p8,p4,p2,p1)
    mv r0 r1           # r1 = p0

    # store p0 in mem[68]
    loadi r2 1
    lshift r2 6        # r2 = 64
    loadi r3 4
    add r2 r3          # r0 = 68
    store r1 r0        # mem[68] = p0

    # get output LSW
    loadi r0 0         # r0 = 0
    add r0 r7          # r0 = index counter
    load r3 r0         # r3 = mem[index counter] = b8:b1
    rshift r3 1        # r3 = 0_b8:b2
    lshift r3 5        # r3 = b4:b2_00000

    loadi r1 1
    lshift r1 6        # r1 = 64
    loadi r0 1         # r0 = 1
    add r0 r1          # r0 = 65
    load r1 r0         # r1 = mem[65] = p4
    lshift r1 4        # r1 = 000_p4_0000
    or r3 r1           # r0 = b4:b2,p4_0000
    mv r0 r2           # r2 = b4:b2,p4_0000

    loadi r0 0         # r0 = 0
    add r0 r7          # r0 = index counter
    load r3 r0         # r3 = mem[index counter] = b8:b1
    lshift r3 7        # r3 = b1_0000000
    rshift r3 4        # r3 = 0000_b1_000
    or r2 r3           # r0 = b4:b2,p4,b1_000
    mv r0 r2           # r2 = b4:b2,p4,b1_000

    loadi r1 1
    lshift r1 6        # r1 = 64
    loadi r0 2         # r0 = 2
    add r0 r1          # r0 = 66
    load r1 r0         # r1 = mem[66] = p2
    lshift r1 2        # r1 = 00000_p2_00
    or r2 r1           # r0 = b4:b2,p4,b1,p2_00
    mv r0 r2           # r2 = b4:b2,p4,b1,p2_00

    loadi r1 1
    lshift r1 6        # r1 = 64
    loadi r0 3         # r0 = 3
    add r0 r1          # r0 = 67
    load r1 r0         # r1 = mem[67] = p1
    lshift r1 1        # r1 = 000000_p1_0
    or r2 r1           # r0 = b4:b2,p4,b1,p2,p1_0
    mv r0 r2           # r2 = b4:b2,p4,b1,p2,p1_0

    loadi r1 1
    lshift r1 6        # r1 = 64
    loadi r0 4         # r0 = 4
    add r0 r1          # r0 = 68
    load r1 r0         # r1 = mem[68] = p0
    or r2 r1           # r0 = b4:b2,p4,b1,p2,p1,p0
    mv r0 r2           # r2 = output LSW

    # store output LSW in mem[30]
    loadi r1 1
    lshift r1 5        # r1 = 32
    loadi r3 2         # r3 = 2
    sub r1 r3          # r0 = 32-2 = 30
    add r0 r7          # r0 = 30 + index counter
    store r2 r0        # mem[30] = output LSW

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
    sub r0 r1
    sub r0 r1

    loadi r1 1
    sub r0 r1           # check if loop counter = 0
    bne r0 Loop

Halt:
    halt