// D Flip Flop posedge negedge
module d_ff_pos_neg (
  input  clk,
  input  d,
  output reg q,
  output reg qneg
);
  always @(posedge clk)
      q <= d;
  
  always @(negedge clk)
      qneg <= d;
  
endmodule

// Testbench
module d_ff_pos_neg_tb;

  reg clk, d;
  wire q, qneg;

  d_ff_pos_neg dut (.clk(clk), .d(d), .q(q), .qneg(qneg));

    initial clk = 0;  
    always #5 clk = ~clk;

    initial begin
      $monitor("Time = %0t clk = %b d = %b q = %b qneg = %b", $time, clk, d, q, qneg);

        d = 0; #15;
        d = 1; #10;
        d = 0; #10;
        d = 1; #10;
        $finish;
    end
endmodule
