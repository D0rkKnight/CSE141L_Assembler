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
    4'b0001: rslt = inB ^ inA;       //xor
    4'b0010: begin                  //bnez
              rslt = inB != 0 ? 1'b1 : 1'b0;
    end
    4'b0011: rslt = inA + inB;     // add
    4'b0100: rslt = inB << inA;     //lshift
    4'b0101: rslt = inB >> inA;     //rshift
    // 4'b1001:                        //pari
    4'b0110: rslt = inB;            //nop_b
    4'b0111: rslt = inA;            //nop_a
    4'b1000: rslt = ^inB;           //pari
    // 4'b1001: rslt = inB;            //nop_b
    4'b1010: rslt = inA | inB;      //or
    4'b1011: rslt = inB - inA;      //sub
  endcase
end
   
endmodule