import sys

# Mapping from register names to register numbers
registers = {
    "r0": "000",
    "r1": "001",
    "r2": "010",
    "r3": "011",
    "r4": "100",
    "r5": "101",
    "r6": "110",
    "r7": "111",
    "pc": "1000",
    "br": "1001",
}

# Mapping from instruction mnemonics to opcodes
opcodes = {
    "load": "0000",
    "store": "0001",
    "xor": "1001",
    "branch": "0011",
    "add": "0100",
    "mv": "0101",
    "lshift": "0110",
    "rshift": "0111",
    "loadi": "1000",
}


def assemble(assembly_code):
    machine_code = []
    for line in assembly_code.split("\n"):
        tokens = line.split()
        if tokens:
            instruction = tokens[0].lower()
            operands = tokens[1:]

            if instruction in {"load", "store", "add", "mv", "xor"}:
                rs, rt = map(registers.get, operands)
                machine_code.append(f"{opcodes[instruction]}{rs}{rt}")
            elif instruction in {"lshift", "rshift"}:
                rs, imm = operands
                machine_code.append(
                    f"{opcodes[instruction]}{registers[rs]}{int(imm):03b}"
                )
            elif instruction == "loadi":
                imm = int(operands[0])
                machine_code.append(f"{opcodes[instruction]}000{imm:04b}")
            elif instruction == "branch":
                imm = int(operands[0])
                machine_code.append(f"{opcodes[instruction]}{int(imm):06b}")
            elif instruction == "parity":
                rs, rt = map(registers.get, operands)
                machine_code.append(f"0010{rs}{rt}")
    return "\n".join(machine_code)


def main():
    if len(sys.argv) != 2:
        print("Usage: python assembler.py <assembly_file>")
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = input_file.split(".")[0] + ".o"

    with open(input_file, "r") as f:
        assembly_code = f.read()

    machine_code = assemble(assembly_code)

    with open(output_file, "w") as f:
        f.write(machine_code)

    print(f"Assembly code has been successfully compiled to {output_file}")


if __name__ == "__main__":
    main()
