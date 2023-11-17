import sys

# Mapping from instruction mnemonics to opcodes
opcodes = {
    "load": "0000",
    "store": "0001",
    "xor": "0010",
    "bne": "0011",
    "add": "0100",
    "mov": "0101",
    "lshift": "0110",
    "rshift": "0111",
    "loadi": "1000",
    "parity": "1001",
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
                imm = parse_imm(int(operands[0]), bits=4)
                machine_code.append(f"{opcodes[instruction]}000{imm}")
            elif instruction == "branch":
                # I type instruction with a 6-bit immediate value
                imm = parse_imm(int(operands[0]), bits=6)
                machine_code.append(f"{opcodes[instruction]}{imm}")
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
