// Edge Detector (both)
module edge_both (
  input  clk,
  input  rst,
  input  signal_in,
  output reg pulse_out
);

  reg signal_d;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      signal_d  <= 0;
      pulse_out <= 0;
    end else begin
      pulse_out <= signal_in ^ signal_d;  
      signal_d  <= signal_in;
    end
  end
endmodule

// Testbench
module edge_both_tb;

  reg clk, rst;
  reg signal_in;
  wire pulse_out;

  edge_both DUT (clk,rst,signal_in,pulse_out);

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    rst = 1; signal_in = 0;
    #20 rst = 0;

    #15 signal_in = 1;
    #20 signal_in = 0;
    #20 signal_in = 1;
    #20 $finish;
  end
  
  initial begin
    $dumpfile("both.vcd");
    $dumpvars;
  end
endmodule
