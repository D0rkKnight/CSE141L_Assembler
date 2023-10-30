import sys


opcodes = {
    "lw": "000",
    "sw": "001",
    "and": "010",
    "inc": "011",
    "dec": "100",
    "lsl": "101",
    "xor": "110",
    "beq": "111",
}

def assemble_instruction(instruction):
    """Convert assembly instruction to machine code."""
    parts = instruction.split()
    operation = parts[0]

    if operation in ["lw", "sw", "and", "inc", "dec", "lsl", "xor"]:
        rd = format(int(parts[1][1]), '03b')
        rs = format(int(parts[2][1]), '03b')
        return opcodes[operation] + rd + rs

    if operation == "beq":
        rd = format(int(parts[1][1]), '03b')
        lookup_index = format(int(parts[2]), '03b')
        
        if len(lookup_index) > 3:
            raise ValueError(f"Lookup index {lookup_index} is too large")
        
        return opcodes[operation] + rd + lookup_index

    raise ValueError(f"Unknown instruction {operation}")

def assemble_program(assembly_code):
    """Convert a program (list of assembly instructions) to machine code."""
    return [assemble_instruction(instruction) for instruction in assembly_code]

# Example program
assembly_program = [
    "lw r0 r7",
    "sw r0 r6",
    "and r0 r1",
    "inc r1 r0",
    "dec r1 r0",
    "lsl r1 r0",
    "xor r0 r1",
    "beq r0 7"
]

machine_code = assemble_program(assembly_program)
for code in machine_code:
    print(code)


def main():
    if len(sys.argv) < 2:
        print("Usage: python assembler.py <filename> [-o output_filename]")
        return

    filename = sys.argv[1]

    # Default output filename
    output_filename = filename.split('.')[0] + ".code"

    # Check if -o tag is provided
    if "-o" in sys.argv:
        try:
            output_filename = sys.argv[sys.argv.index("-o") + 1]
        except IndexError:
            print("Error: Output filename not provided after '-o' tag.")
            return

    # Read assembly instructions from the input file
    with open(filename, "r") as infile:
        assembly_program = infile.readlines()
        assembly_program = [line.strip() for line in assembly_program]  # Remove newline characters

    machine_code = assemble_program(assembly_program)

    # Write machine code to the output file
    with open(output_filename, "w") as outfile:
        for code in machine_code:
            outfile.write(code + "\n")

if __name__ == "__main__":
    main()
