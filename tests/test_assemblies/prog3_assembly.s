# 3a

# Register layout:
# r5: sub-byte position
# r6: current byte
# r7: pattern

# Load pattern from mem[32]
loadi r1 32
load r2 r1
mv r2 r7

# Iterate over every byte
Loop:
    # Load byte from mem[r6]
    load r1 r6

    # Compare byte with pattern
BitLoop:

BitLoopEnd:


    sub r1 r7
    bne Skip

Skip:
    
    # increment r6
    loadi r1 1
    add r1 r6
    mv r0 r6

    # Check if r6 == 32 (using r0 as surrogate)
    loadi r1 2
    shiftl r1 5
    sub r1 r0

    bne Loop

End:
    # Return r6
    mv r6 r0
    ret