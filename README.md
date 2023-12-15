Instruction Format
R-type Instructions:

Format: opcode (4 bits) | rs (2 bits) | rt (3 bits)
Supported Operations: load, store, add, mv, xor, parity, or, sub, lsr, rsr

I-type Instructions:

Format: opcode (4 bits) | rs (2 bits) | immediate (3 bits)
Supported Operations: lshift, rshift, loadi

Branch Instructions:

Format: opcode (4 bits) | branch target index (5 bits)
Supported Operations: bne

Special Instructions:

halt: opcode (4 bits) | unused (5 bits)
Description: Stops the execution of the program.

Opcode Encoding
load: 0000
store: 0001
xor: 0010
bne: 0011
add: 0100
mv: 0101
lshift: 0110
rshift: 0111
loadi: 1000
parity: 1001
halt: 1010
or: 1011
sub: 1100
lsr: 1101
rsr: 1110

Notes:
There are a maximum of 32 branch targets
R type instructions write to r0, except for parity and mv, which write to rt
Labels are described by name:
Comments start with #


Hardware:
We went with a standard MIPS machine with a 32 entry tall absolute jump table. We assemble the jump table and place it into the first 32 lines of the instruction ROM. On the hardware side, we read that data into the PC lookup module.

We halt the program with a special halt instruction. Since we had no other syscalls, we decided to leave the registers unused for the halt instr.

Software Approach:
Since rs and rt take a different number of registers, we shield against that (and other errors like out-of-range immediates) at the assembler level. We also decided to leave a couple of unused instructions in case we overlooked anything, which came in helpful when writing the assembly (sub, or, halt, lsr, and rsr got added afterwards).