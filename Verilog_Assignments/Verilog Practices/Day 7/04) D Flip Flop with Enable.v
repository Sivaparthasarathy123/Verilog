// D Flip Flop Enable
module d_ff_en (
  input  wire clk,
  input  wire en,
  input  wire d,
  output reg  q
);
    
  always @(posedge clk) begin
    if (en)
      q <= d;
    else
      q <= 0;
    end
  
endmodule

// Testbench
module d_ff_en_tb;

  reg clk, en, d;
  wire q;

  d_ff_en dut (.clk(clk), .en(en), .d(d), .q(q));

    initial clk = 0;  
    always #5 clk = ~clk;

    initial begin
      $monitor("Time = %0t clk = %b d = %b q = %b en = %b", $time, clk, d, q, en);

        en = 0;#10;
        en = 1;#10;
        d = 0; #15;
        d = 1; #10;
        d = 0; #10;
        $finish;
    end
endmodule
