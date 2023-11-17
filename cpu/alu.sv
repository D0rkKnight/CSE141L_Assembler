// combinational -- no clock
// sample -- change as desired
module alu(
  input[3:0] alu_cmd,    // ALU instructions
  input[7:0] inA, inB, inC,	 // 8-bit wide data path
  input      sc_i,       // shift_carry in
  output logic[7:0] rslt,
  output logic sc_o,     // shift_carry out
               pari,     // reduction XOR (output)
               branch_bool
);

always_comb begin 
  rslt = 'b0;            
  sc_o = 'b0;    
  pari = ^rslt;
  case(alu_cmd)
    4'b0000: rslt = inA;            //load
    4'b0001: rslt = inA;            //store
    4'b0010: rslt = inB ^ inA       //xor
    4'b0011: begin                  //bne
              rslt = (inA != inB) ? inC : 8'b0;
              branch_bool = (inA != inB) ? 1'b1 : 1'b0;
    end
    4'b0100: rslt = inA + inB;
    4'b0101: rslt = inA;            //mov
    4'b0110: rslt = inB << inA;     //lshift
    4'b0111: rslt = inB >> inA;     //rshift
    4'b1000:                        //loadi
    4'b1001:                        //pari
  endcase
end
   
endmodule