// Mod 16 Counter with parallel load
module mod16_parallel_load_counter(
  input clk,
  input rst,
  input load,
  input [3:0] data,
  output reg [3:0] count
);

  always @(posedge clk)
    begin
      if(rst)
        count <= 0;

      else if(load)
        count <= data;

      else if(count == 15)
        count <= 0;

      else
        count <= count + 1;
    end

endmodule

// Testbench
module mod16_parallel_load_tb;

  reg clk;
  reg rst;
  reg load;
  reg [3:0] data;
  wire [3:0] count;

  mod16_parallel_load_counter dut(clk, rst, load, data, count
                                 );
  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    $monitor("Time = %0t rst = %b load = %b data = %d count = %d",$time, rst, load, data, count);

    rst = 1;
    load = 0;
    data = 4'b0000;

    #10 rst = 0;
    #50;

    // Load 
    load = 1;
    data = 4'b1010; 
    #10;

    load = 0;
    #100;

    $finish;
  end

endmodule
