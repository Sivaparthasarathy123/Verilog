// Edge Detector (Rising)
module edge_rising (
  input clk,
  input rst,
  input signal_in,
  output reg pulse_out
);

  reg signal_d;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      signal_d <= 0;
      pulse_out <= 0;
    end 
    else begin
      pulse_out <= signal_in & ~signal_d;
      signal_d <= signal_in;
    end
  end

endmodule

// Testbench
module edge_rising_tb;

  reg clk;
  reg rst;
  reg signal_in;
  wire pulse_out;

  edge_rising dut (clk, rst, signal_in, pulse_out);

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    $dumpfile("edge_rising.vcd");
    $dumpvars;

    rst = 1;
    signal_in = 0;

    #20;
    rst = 0;

    // Rising edge
    #15 signal_in = 1;  
    #10 signal_in = 1;  

    // Falling edge
    #10 signal_in = 0;

    // Rising again
    #15 signal_in = 1;

    // toggling condition
    #10 signal_in = 0;
    #10 signal_in = 1;
    #10 signal_in = 0;
    #10 signal_in = 1;

    repeat (10) begin
      #10 signal_in = $urandom_range(0,1);
    end

    #50;
    $finish;
  end

endmodule
