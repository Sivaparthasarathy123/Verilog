// Pulse Stretcher
module pulse_stretcher(
  input clk,
  input rst,
  input signal_in,
  output reg pulse_st
);
  
  reg [2:0] counter;
  
  always@(posedge clk)begin
    if(rst)begin
      pulse_st <= 0;
      counter <= 0;
    end
    else begin
      if(signal_in)
        counter <= 4;
      if(counter > 0) 
        counter <= counter - 1;
      
      pulse_st <= (counter > 0);
    end
  end
    
endmodule

// Testbench
`timescale 1ns/1ps;
module pulse_stretch_tb;
  reg clk;
  reg rst;
  reg signal_in;
  wire pulse_st;
  
  pulse_stretcher dut (clk,rst,signal_in,pulse_st);
  
  initial clk = 0;
  always #5 clk = ~clk;
  
  initial begin
    $dumpfile("pulse_stretch.vcd");
    $dumpvars;
    
    rst = 1;
    #20 rst = 0;
    
    #20 signal_in = 1;
    #10 signal_in = 0;
    
    #100 signal_in = 1;
    #120 signal_in = 0;
    #200 signal_in = 1;
    
    #500 $finish;
  end
  
endmodule
  
