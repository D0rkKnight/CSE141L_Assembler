import sys

# Mapping from instruction mnemonics to opcodes
opcodes = {
    "load": "0000",
    "store": "0001",
    "xor": "0010",
    "bne": "0011",
    "add": "0100",
    "mv": "0101",
    "lshift": "0110",
    "rshift": "0111",
    "loadi": "1000",
    "parity": "1001",
    "halt": "1010"
}
 
# Expects rn to be a string of the form "r0", "r1", ..., "r7"
def get_reg_num(register: str, bits_avail: int = 3) -> str:
    
    # Get rid of the "r" in the register string
    register = register[1:]
    
    # Convert the register number to binary
    register_number = int(register)
    register_binary = bin(register_number)[2:]
    
    # Pad the binary number with 0s to the left
    register_binary = register_binary.zfill(bits_avail)
    
    # If the register number is too large, raise an error
    if len(register_binary) > bits_avail:
        raise ValueError(f"Register number {register_number} is too large")
    
    return register_binary

def parse_imm(imm: int, bits: int) -> str:
    imm_bin = f"{imm:0{bits}b}"
    if imm >= 2**bits or imm < 0:
        raise ValueError(f"Immediate value {imm} cannot be represented in {bits} bits")
    return imm_bin

def assemble(assembly_code):
    machine_code = []
    for line in assembly_code.split("\n"):
        tokens = line.split()
        if tokens:
            instruction = tokens[0].lower()
            operands = tokens[1:]
            
            if instruction == '#':
                continue

            if instruction in {"load", "store", "add", "mv", "xor", "parity"}:
                # R type instructions with format [4:2:3] for opcode-rs-rt
                rs = get_reg_num(operands[0], bits_avail=2)
                rt = get_reg_num(operands[1], bits_avail=3)
                machine_code.append(f"{opcodes[instruction]}{rs}{rt}")
            elif instruction in {"lshift", "rshift"}:
                # I type instructions with format [4:2:3] for opcode-rs-i
                rs = get_reg_num(operands[0], bits_avail=2)
                imm = parse_imm(int(operands[1]), bits=3)
                machine_code.append(f"{opcodes[instruction]}{rs}{imm}")
            elif instruction == "loadi":
                # I type instruction with a 4-bit immediate value
                rs = get_reg_num(operands[0], bits_avail=2)
                imm = parse_imm(int(operands[1]), bits=3)
                machine_code.append(f"{opcodes[instruction]}{rs}{imm}")
            elif instruction in {"bne", "halt"}:
                # I type instruction with a 6-bit immediate value
                imm = parse_imm(int(operands[0]), bits=5)
                machine_code.append(f"{opcodes[instruction]}{imm}")
    
    # Check if the last instruction is a halt instruction
    if machine_code[-1][0:4] != "1010":
        print("Warning: Last instruction is not a halt instruction. Adding halt instruction to the end of the program")
        machine_code.append(opcodes["halt"] + "00000")    
    
    return "\n".join(machine_code)



def main():
    if len(sys.argv) != 3:
        print("Usage: python assembler.py <assembly_file>")
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = sys.argv[2]

    with open(input_file, "r") as f:
        assembly_code = f.read()

    machine_code = assemble(assembly_code)

    with open(output_file, "w") as f:
        f.write(machine_code)

    print(f"Assembly code has been successfully compiled to {output_file}")


if __name__ == "__main__":
    main()

### Documentation
'''
R-type Instructions: These instructions operate on register values. The format is [4-bit opcode][2-bit source register rs][3-bit target register rt].
I-type Instructions: These instructions include immediate values. The format is [4-bit opcode][2-bit register rs][3-bit immediate value i] or [4-bit opcode][5-bit immediate value i].

Opcode Mapping
Each mnemonic maps to a 4-bit opcode. Here's the mapping given in the assembler code:

load - 0000
store - 0001
xor - 0010
bne - 0011
add - 0100
mov - 0101
lshift - 0110
rshift - 0111
loadi - 1000
parity - 1001
halt - 1010
Instructions Details
Load and Store

load rs, rt - Load the value from the address in rs to rt.
store rs, rt - Store the value from rt into the address in rs.
Arithmetic and Logical Operations

add rs, rt - Add values in rs and rt, store result in rt.
xor rs, rt - Perform bitwise XOR on rs and rt, store result in rt.
lshift rs, i - Left shift the value in rs by i bits.
rshift rs, i - Right shift the value in rs by i bits.
parity rs, rt - Check parity of the value in rs and store result in rt.
Immediate Operations

loadi rs, i - Load immediate value i into rs.
Branch and Control

bne i - Branch if not equal to immediate value i.
halt - Stop execution.
'''