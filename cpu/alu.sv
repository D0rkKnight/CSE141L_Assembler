// combinational -- no clock
// sample -- change as desired
module alu #(parameter A = 3)(
  input[A:0] alu_cmd,    // ALU instructions
  input[7:0] inA, inB,	 // 8-bit wide data path
  input      sc_i,       // shift_carry in
  output logic[7:0] rslt,
  output logic sc_o,     // shift_carry out
               pari     // reduction XOR (output)
);

always_comb begin 
  rslt = 'b0;            
  sc_o = 'b0;    
  pari = ^rslt;
  case(alu_cmd)
    3'b0001: rslt = inB ^ inA;       //xor
    3'b0010: begin                  //bne
              rslt = inA != 0 ? 1'b1 : 1'b0;
    end
    3'b0011: rslt = inA + inB;     // add
    3'b0100: rslt = inB << inA;     //lshift
    3'b0101: rslt = inB >> inA;     //rshift
    // 3'b1001:                        //pari
    3'b0110: rslt = inB;           // select 2nd
    3'b0111: rslt = inA;            //nop
    3'b1000: rslt = ^inB;           //pari
  endcase
end
   
endmodule