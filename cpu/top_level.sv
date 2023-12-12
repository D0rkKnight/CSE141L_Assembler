// sample top level design
module top_level(
  input        clk, reset, req, 
  output logic done);
  parameter D = 10,             // program counter width
            A = 3,             		  // ALU command bit width
            B = 5,            		  // branch table depth
            REG_BITS = 3;
  wire[D-1:0] target, 			  // jump 
              prog_ctr;
  wire        RegWrite;
  wire[7:0]   datA,datB,		  // from RegFile
              muxA, 
              rslt,               // alu output
              immed;
  logic sc_in,   				  // shift/carry out from/to ALU
        pariQ,              	  // registered parity flag from ALU
        zeroQ;                    // registered zero flag from ALU 
  wire  relj;                     // from control to PC; relative jump enable
  wire  pari,
        zero,
        sc_clr,
        sc_en,
        MemWrite,
        ALUSrc,		              // immediate switch
        MemtoReg,                // load switch
        Halt;                   // halt switch
  wire[A:0] alu_cmd;
  wire[8:0]   mach_code;          // machine code
  wire[2:0] rd_addrA, rd_addrB, dst_reg;    // address pointers to reg_file
  wire[1:0] RegDst;

  wire[7:0] mem_out;          // Memory output
  wire[7:0] regfile_dat;      // data to reg_file
  wire[D-1:0] branch_table [2**B];   // branch target address
  wire[B-1:0] branch_tag;       // branch tag
// fetch subassembly
  PC #(.D(D)) 					  // D sets program counter width
     pc1 (.reset            ,
          .clk              ,
          // .reljump_en (relj),
          .absjump_en (branch_taken),
          .target           ,
          .prog_ctr          );

// lookup table to facilitate jumps/branches
  PC_LUT #(.D(D), .B(B))
    pl1 (.addr  (branch_tag),
         .target,          
         .branch_table);   

// contains machine code
  instr_ROM #(.D(D), .B(B))
    ir1(.prog_ctr,
        .mach_code,
        .branch_table);

// control decoder
  Control #(.opwidth(A))
    ctl1(.instr(mach_code),
    .Branch  (absj)  , 
    .MemWrite , 
    .ALUSrc   , 
    .RegWrite   ,     
    .MemtoReg,
    .ALUOp(alu_cmd),
    .Halt,
    .RegDst);

  assign rd_addrA = mach_code[2:0];
  assign rd_addrB = mach_code[4:3];
  assign branch_tag = mach_code[4:0];
  // assign immed = {{5{mach_code[2]}}, mach_code[2:0]}; // Sign extended immediate value (Right 3 bits)
  assign immed = mach_code[2:0]; // Don't sign extend immediate value (Right 3 bits)

  reg_file #(.pw(REG_BITS)) rf1(.dat_in(regfile_dat),	   // loads, most ops
              .clk         ,
              .wr_en   (RegWrite),
              .rd_addrA(rd_addrA),
              .rd_addrB(rd_addrB),
              .wr_addr (dst_reg),      // in place operation
              .datA_out(datA),
              .datB_out(datB)); 

  assign muxA = ALUSrc? immed : datA;
  assign regfile_dat = MemtoReg? mem_out : rslt;
  assign branch_taken = (rslt == 1'b1) && (absj == 1'b1);
  assign dst_reg = (RegDst == 2'b00) ? 3'b0 :
                    (RegDst == 2'b01) ? rd_addrB :
                    (RegDst == 2'b10) ? rd_addrA : 3'bx;

  alu #(.A(A)) 
    alu1(.alu_cmd,
            .inA    (muxA),
            .inB    (datB),
            .sc_i   (sc),   // output from sc register
            .rslt       ,
            .sc_o   (sc_o), // input to sc register
            .pari  );  

  dat_mem dm1(.dat_in(datB)  ,  // from reg_file
             .clk           ,
			        .wr_en  (MemWrite), // stores
			        .addr   (datA),
              .dat_out(mem_out));

// registered flags from ALU
  always_ff @(posedge clk) begin
    pariQ <= pari;
	  zeroQ <= zero;

    if(sc_clr)
	    sc_in <= 'b0;
    else if(sc_en)
      sc_in <= sc_o;
  end

  assign done = Halt;

  // assign done = 1'b1;
 
endmodule