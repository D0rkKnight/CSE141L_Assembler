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

# Initialize mem[33-35] to 0
loadi r1 1
lshift r1 5
loadi r2 1
add r1 r2

loadi r1 0
store r1 r0
add r0 r2
store r1 r0
add r0 r2
store r1 r0

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

    # r1 = r1 | r2
    or r1 r2
    mv r0 r1

    # Now we have the subbit.

    # Check if subbit matches pattern.
    sub r1 r7
    bne NoMatch

    # Check if subbit is in the middle of a byte.
    # r5 = 0,1,2,or 3
    @ loadi r1 0
    @ sub r1 r5
    @ bne Not0

    @ loadi r0 1
    @ bne InByteMatch

Not0:
    @ loadi r1 1
    @ sub r1 r5
    @ bne Not1

    @ loadi r0 1
    @ bne InByteMatch

@ Not1:
@     loadi r1 2
@     sub r1 r5
@     bne Not2

@     loadi r0 1
@     bne InByteMatch

@ Not2:
@     loadi r1 3
@     sub r1 r5
@     bne Not3

@     loadi r0 1
@     bne InByteMatch

@ Not3:
@     loadi r1 4
@     sub r1 r5
@     bne NoInByteMatch

@     loadi r0 1
@     bne InByteMatch

InByteMatch:
    
    # Log in byte match, mem[33] += 1
    @ loadi r2 1
    @ lshift r2 5
    @ loadi r3 1
    @ add r2 r3
    @ mv r0 r2 // r2=33

    @ load r3 r2
    @ loadi r0 1
    @ add r3 r0
    @ store r0 r2

NoInByteMatch:

    # Log cross-byte match
    # Match found, mem[35] += 1
    loadi r2 1
    lshift r2 5
    loadi r3 3
    add r2 r3
    mv r0 r2 // r2=35

    load r3 r2
    loadi r0 1
    add r3 r0
    store r0 r2

NoMatch:

    # r5 += 1
    loadi r2 1
    add r2 r5
    mv r0 r5

    # If byte is b31, check if r5 == 3 instead and if so, skip to end.
    loadi r2 1
    lshift r2 5
    loadi r0 1
    sub r2 r0
    mv r0 r2 # r2 = 31

    loadi r0 0
    add r0 r6
    sub r0 r2 # r0 = r6-31

    bne NotB31

    # Check if r5 == (3+1)
    loadi r0 4
    sub r0 r5
    bne NotSubbit3

    loadi r0 1
    bne BitLoopEnd

NotB31:
NotSubbit3:

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