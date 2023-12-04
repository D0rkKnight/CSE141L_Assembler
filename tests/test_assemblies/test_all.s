# Test Load and Store
load r0 r1  # Load value at address in r0 into r1
store r1 r2 # Store value in r1 into address in r2

# Test Arithmetic and Logical Operations
add r3 r4   # Add values in r3 and r4, store result in r4
xor r4 r5   # Perform XOR on r4 and r5, store result in r5
lshift r2 1 # Left shift the value in r2 by 1 bit
rshift r2 1 # Right shift the value in r2 by 1 bit
parity r5 r6 # Check parity of value in r5, store result in r6

# Test Immediate Operations
loadi r1 5  # Load immediate value 5 into r1

# Test Branch and Control
# Assuming bne performs a relative branch if the value in a register is not equal to the immediate value
bne 3        # Branch to tag_3 if the condition is met (condition not specified in ISA)
halt         # Stop execution

# Branch Tags and Additional Instructions
tag_3:       # Branch target
    loadi r1 10 # Load immediate value 10 into r1
    halt         # Stop execution