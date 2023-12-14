# 3a

# Register layout:
# r5: sub-byte position
# r6: current byte
# r7: pattern

# Load pattern from mem[32]
loadi r1 1
lshift r1 5
load r2 r1
mv r2 r7

# Iterate over every byte
Loop:

    # Compare byte with pattern
BitLoop:

    # Build combination byte
    # Load byte from mem[r6]
    load r1 r6
    lsr r1 r5

    # r2 = r6+1
    loadi r2 1
    add r2 r6
    mv r0 r2

    # If byte+1 is b32, load 0
    loadi r3 1
    lshift r3 5
    sub r3 r2
    bne byte2Exists

    # byte+1 is b32, r2=0
    loadi r2 0
    loadi r0 1
    bne byte2Resolved

byte2Exists:
    # r2 = mem[r2]
    load r2 r2

    # r2 = r2 << (8-r5)
    loadi r3 1
    lshift r3 3

    sub r3 r5
    mv r0 r3

    lsr r2 r3

    # r2 = r2 >> (8-r5)
    rsr r2 r3

byte2Resolved:

    # r1 = r1 | r2
    or r1 r2
    mv r0 r1

    # Now we have the subbit.

    # r5 += 1
    loadi r2 1
    add r2 r5
    mv r0 r5

    # if r5 == 8
    loadi r2 1
    lshift r2 3

    sub r2 r5
    bne BitLoop

BitLoopEnd:

    # zero out r5
    loadi r1 0
    mv r1 r5

    # increment r6
    loadi r1 1
    add r1 r6
    mv r0 r6

    # if r6 == 32 (using r0 as surrogate)
    loadi r1 1
    lshift r1 5
    sub r1 r0

    bne Loop

End: