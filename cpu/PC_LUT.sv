module PC_LUT #(parameter D = 12, B = 5) (
    input       [B-1:0] addr,        // Address to select one of the 2**B values
    input       [D-1:0] branch_table [(2**B)-1:0], // Array of 2**B D-bit inputs
    output logic [D-1:0] target
);

    always_comb begin
        target = branch_table[addr]; // Index into branch_table using addr
    end

endmodule

/*

	   pc = 4    0000_0000_0100	  4
	             1111_1111_1111	 -1

                 0000_0000_0011   3

				 (a+b)%(2**12)


   	  1111_1111_1011      -5
      0000_0001_0100     +20
	  1111_1111_1111      -1
	  0000_0000_0000     + 0


  */
