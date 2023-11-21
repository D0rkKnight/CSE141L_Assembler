// control decoder
module Control #(parameter opwidth = 3, mcodebits = 9)(
  input [mcodebits-1:0] instr,    // subset of machine code (any width you need)
  output logic RegDst, Branch, 
     MemtoReg, MemWrite, ALUSrc, RegWrite,
  output logic[opwidth-1:0] ALUOp);	   // for up to 8 ALU operations

always_comb begin
// defaults
  RegDst 	=   'b0;   // 1: not in place  just leave 0 NOTE: We don't use this at all.
  Branch 	=   'b0;   // 1: branch (jump)
  MemWrite  =	'b0;   // 1: store to memory
  ALUSrc 	=	'b0;   // 1: immediate  0: second reg file output
  RegWrite  =	'b1;   // 0: for store or no op  1: most other operations 
  MemtoReg  =	'b0;   // 1: load -- route memory instead of ALU to reg_file data in
  ALUOp	    =   'b111; // y = a+0; nop
// sample values only -- use what you need
case(instr[8:5])    // override defaults with exceptions
  4'b0000:  //load
    begin                       
      MemtoReg = 'b1;
    end
  4'b0001:  //store
    begin                       
      RegWrite = 'b0;
      MemWrite = 'b1;
    end
  4'b0010:  //xor
    begin
      ALUOp = 'b001;
    end
  4'b0011:  //bne
    begin
      ALUOp = 'b010;
      Branch = 'b1;
      RegWrite = 'b0;
    end 
  4'b0100:  //add
    begin
      ALUOp = 'b011;
    end 
  4'b0101:  //mov
    begin
    end
  4'b0110:  //lshift
    begin
      ALUOp = 'b100;
      ALUSrc = 'b1;
    end
  4'b0111:  //rshift
    begin
      ALUOp = 'b101;
      ALUSrc = 'b1;
    end
  4'b1000:  //loadi
    begin
      ALUOp = 'b110;
      ALUSrc = 'b1;
    end
  // 4'b1001:  //pari
endcase

end
	
endmodule