// sample top level design
module top_level(
  input        clk, reset, req, 
  output logic done);
  parameter D = 10,             // program counter width
            A = 3,             		  // ALU command bit width
            REG_BITS = 3;
  wire[D-1:0] target, 			  // jump 
              prog_ctr;
  wire        RegWrite;
  wire[7:0]   datA,datB,		  // from RegFile
              muxB, 
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
        MemtoReg;                // load switch
  wire[A-1:0] alu_cmd;
  wire[8:0]   mach_code;          // machine code
  wire[2:0] rd_addrA, rd_addrB;    // address pointers to reg_file

  wire[7:0] mem_out;          // Memory output
  wire[7:0] regfile_dat;      // data to reg_file
// fetch subassembly
  PC #(.D(D)) 					  // D sets program counter width
     pc1 (.reset            ,
          .clk              ,
          // .reljump_en (relj),
          .absjump_en (absj),
          .target           ,
          .prog_ctr          );

// lookup table to facilitate jumps/branches
  PC_LUT #(.D(D))
    pl1 (.addr  (immed),
         .target          );   

// contains machine code
  instr_ROM #(.D(D))
    ir1(.prog_ctr,
               .mach_code);

// control decoder
  Control #(.opwidth(A))
    ctl1(.instr(),
    .RegDst  (), 
    .Branch  (absj)  , 
    .MemWrite , 
    .ALUSrc   , 
    .RegWrite   ,     
    .MemtoReg,
    .ALUOp(alu_cmd));

  assign rd_addrA = mach_code[2:0];
  assign rd_addrB = mach_code[4:3];
  assign immed = {{5{mach_code[2]}}, mach_code[2:0]}; // Sign extended immediate value

  reg_file #(.pw(REG_BITS)) rf1(.dat_in(regfile_dat),	   // loads, most ops
              .clk         ,
              .wr_en   (RegWrite),
              .rd_addrA(rd_addrA),
              .rd_addrB(rd_addrB),
              .wr_addr (rd_addrB),      // in place operation
              .datA_out(datA),
              .datB_out(datB)); 

  assign muxB = ALUSrc? immed : datB;
  assign regfile_dat = MemtoReg? mem_out : rslt;
  assign branch_taken = (rslt == 1'b1) && (absj == 1'b1);

  alu #(.A(A)) 
    alu1(.alu_cmd(),
            .inA    (datA),
            .inB    (muxB),
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

  assign done = prog_ctr == 128;

  // assign done = 1'b1;
 
endmodule