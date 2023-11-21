// CSE141L  Winter 2023
// test bench for checking "imm r0 5" instruction
module imm_r0_tb();

bit clk;               // clock source -- drives DUT input of same name
bit req;               // req -- start instruction -- drives DUT input
wire done;             // ack -- from DUT -- done w/ instruction

top_level DUT(.clk(clk), .reset(req), .req(req), .done(done));

initial begin
  #10ns req = 1'b1;     // pulse request to DUT to start instruction
  #10ns req = 1'b0;

  wait(done);           // wait for ack from DUT

  $display("Testing imm r0 3 instruction");
  if (DUT.rf1.core[0] == 5'b00011) begin
      $display("Test Passed: r0 contains the value 3");
  end
  else begin
      $display("Test Failed: r0 contains %d", DUT.rf1.core[0]);
  end
  #10ns $stop;
end

always begin
  #5ns clk = 1;         // tic
  #5ns clk = 0;         // toc
end

endmodule
