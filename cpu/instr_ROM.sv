// lookup table
// deep 
// 9 bits wide; as deep as you wish
module instr_ROM #(parameter D = 12, parameter B = 8) (
    input        [D-1:0] prog_ctr,    // Program counter address pointer
    output logic [8:0] mach_code,     // Machine code output
    output logic [D-1:0] branch_table[B] // Branch table output
);

    localparam TOTAL_SIZE = 2**D + B; // Total size including branch table and core
    logic [8:0] memory[TOTAL_SIZE];   // Combined memory for branch table and core

    // Load the program and branch table
    initial $readmemb("mach_code.txt", memory);

    // Assign machine code based on program counter
    always_comb mach_code = memory[prog_ctr + B]; // Offset by B to account for branch table

    // Assign branch table values
    generate
        genvar i;
        for (i = 0; i < B; i++) begin : assign_branch_table
            always_comb branch_table[B-i-1] = memory[i];
            // always_comb branch_table[B-i] = i;
        end
    endgenerate

endmodule


/*
sample mach_code.txt:

001111110		 // ADD r0 r1 r0
001100110
001111010
111011110
101111110
001101110
001000010
111011110
*/