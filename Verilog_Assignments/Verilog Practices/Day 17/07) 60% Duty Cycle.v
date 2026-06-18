// 2) Write RTL code to generate a 60% duty-cycle output clock using a counter-based approach, where a function calculates HIGH-time and LOW-time counts based on a programmable period.

module duty60_clock_gen(
  input clk,
  input rst,
  input [7:0]period,
  output reg clk_out
);

  reg [7:0]counter;

  // Function for High Count
  function [7:0] get_high_count;
    input [7:0] p;
    begin
      get_high_count = (p * 60)/100;
    end
  endfunction

  // Function for Low count 
  function [7:0] get_low_count;
    input [7:0] p;
    begin
      get_low_count = p - get_high_count(p);
    end
  endfunction

  wire [7:0] high_count;
  wire [7:0] low_count;

  assign high_count = get_high_count(period);
  assign low_count  = get_low_count(period);

  // Counter
  always @(posedge clk)begin
    if(rst)begin
      counter <= 0;
      clk_out <= 0;
    end
    else begin
      if(counter == period-1)
        counter <= 0;
      else
        counter <= counter + 1;

      // Generating 60% Duty Cycle
      if(counter < high_count)
        clk_out <= 1'b1;
      else
        clk_out <= 1'b0;

    end
  end

endmodule

// Testbench
`timescale 1ns/1ps
module duty60_clock_gen_tb;

  reg clk;
  reg rst;
  reg [7:0]period;
  wire clk_out;

  duty60_clock_gen dut(clk, rst, period clk_out);

  always #5 clk = ~clk;

  integer high_cycles;
  integer low_cycles;
  integer i;

  initial begin

    clk = 0;
    rst = 1;

    period = 10;

    high_cycles = 0;
    low_cycles  = 0;

    #20;
    rst = 0;

    repeat(20)begin
      @(posedge clk);

      if(clk_out)
        high_cycles = high_cycles + 1;
      else
        low_cycles = low_cycles + 1;
    end

    $display("\nMeasured Results");
    $display("---------------------");
    $display("High Cycles = %0d",high_cycles);
    $display("Low Cycles  = %0d",low_cycles);

    // Duty Cycle
    if(high_cycles == 12 && low_cycles  == 8)begin
      $display("PASS -> 60%% Duty Cycle Generated");
    end
    else begin
      $display("FAIL -> Incorrect Duty Cycle");
    end

    period = 20;

    high_cycles = 0;
    low_cycles  = 0;

    repeat(20)begin
      @(posedge clk);

      if(clk_out)
        high_cycles = high_cycles + 1;
      else
        low_cycles = low_cycles + 1;
    end

    $display("\nPeriod Changed To 20");

    $display("High Cycles = %0d",high_cycles);
    $display("Low Cycles  = %0d",low_cycles);

    $finish;

  end

  initial begin
    $monitor("T = %0t Period = %0d Counter = %0d clk_out = %b",$time, period,
             dut.counter, clk_out);
  end

endmodule
