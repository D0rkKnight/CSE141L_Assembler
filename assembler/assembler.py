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
    "halt": "1010",
    "or": "1011",
    "sub": "1100",
    "lsr": "1101",
    "rsr": "1110",
}

BRANCH_TARGET_BITS = 5
COMMENTS = ["#", "//", "@"]

 
# Expects rn to be a string of the form "r0", "r1", ..., "r7"
def get_reg_num(register: str, bits_avail: int = 3, instr: str = "sample_instr") -> str:
    
    # Get rid of the "r" in the register string
    register = register[1:]
    
    if (register == ""):
        raise ValueError(f"Register number cannot be empty (instr {instr})")
    
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
    branch_table = []
    prog_ctr = 0
    
    # Populate branch table
    for line in assembly_code.split("\n"):
        tokens = line.split()
        if tokens:
            instruction = tokens[0].lower()
            operands = tokens[1:]
            
            if instruction in COMMENTS:
                continue
            
            # Is a branch instruction
            if instruction[-1] == ':':
                branch_table.append((instruction[:-1], prog_ctr))
            
            else:
                prog_ctr += 1
    
    if len(branch_table) > 2 ** BRANCH_TARGET_BITS:
        raise ValueError(f"Too many branch targets. Maximum number of branch targets is {2 ** BRANCH_TARGET_BITS}")
    
    # Build branch target block
    branch_target_block = []
    for label, target in branch_table:
        branch_target_block.append(f"{target:09b}")
        
    # Pad until 8 entries
    while len(branch_target_block) < 2 ** BRANCH_TARGET_BITS:
        branch_target_block.append("0"*9)
    
    for line in assembly_code.split("\n"):
        tokens = line.split()
        
        try:
            if tokens:
                instruction = tokens[0].lower()
                operands = tokens[1:]
                
                if instruction in COMMENTS:
                    continue
                
                # Is a branch instruction
                if instruction[-1] == ':':
                    continue
                
                if instruction not in opcodes:
                    raise ValueError(f"Invalid instruction {instruction}")

                if instruction in {"load", "store", "add", "mv", "xor", "parity", "or", "sub", "lsr", "rsr"}:
                    # R type instructions with format [4:2:3] for opcode-rs-rt
                    rs = get_reg_num(operands[0], bits_avail=2, instr=instruction)
                    rt = get_reg_num(operands[1], bits_avail=3, instr=instruction)
                    machine_code.append(f"{opcodes[instruction]}{rs}{rt}")
                elif instruction in {"lshift", "rshift"}:
                    # I type instructions with format [4:2:3] for opcode-rs-i
                    rs = get_reg_num(operands[0], bits_avail=2, instr=instruction)
                    imm = parse_imm(int(operands[1]), bits=3)
                    machine_code.append(f"{opcodes[instruction]}{rs}{imm}")
                elif instruction == "loadi":
                    # I type instruction with a 4-bit immediate value
                    rs = get_reg_num(operands[0], bits_avail=2, instr=instruction)
                    imm = parse_imm(int(operands[1]), bits=3)
                    machine_code.append(f"{opcodes[instruction]}{rs}{imm}")
                elif instruction in {"bne"}:
                    # I type instruction with a 6-bit immediate value
                    rs = 0
                    
                    branch_target = operands[0]
                    branch_target_exists = False
                    branch_target_index = None
                    i = 0
                    for label, target in branch_table:
                        if label == branch_target.lower():
                            branch_target_exists = True
                            branch_target_index = i
                            break
                        i += 1
                    if not branch_target_exists:
                        raise ValueError(f"Branch target {branch_target.lower()} does not exist")
                    
                    
                    
                    print(f"rs: {rs}")
                    print(f"Branch target {branch_target} found at index {branch_target_index}")
                    
                    machine_code.append(f"{opcodes[instruction]}{branch_target_index:05b}")
                elif instruction == "halt":
                    machine_code.append(f"{opcodes[instruction]}00000")
        except Exception as e:
            print(f"Error: {e}")
            print(f"Error occurred at line: {line}")
            print(f"Branch table: {branch_table}")
            sys.exit(1)
    
    # Check if the last instruction is a halt instruction
    if machine_code[-1][0:4] != "1010":
        print("Warning: Last instruction is not a halt instruction. Adding halt instruction to the end of the program")
        machine_code.append(opcodes["halt"] + "00000")    
        
    return "\n".join(branch_target_block + machine_code)



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
Instruction Format
R-type Instructions:

Format: opcode (4 bits) | rs (2 bits) | rt (3 bits)
Supported Operations: load, store, add, mv, xor, parity, or, sub, lsr

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

Notes:
There are a maximum of 32 branch targets
R type instructions write to r0, except for parity and mv, which write to rt
Labels are described by name:
Comments start with #
'''