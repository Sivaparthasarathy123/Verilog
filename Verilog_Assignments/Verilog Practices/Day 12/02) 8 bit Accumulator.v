// 4 bit Accumulator
module accumulator #(parameter WIDTH = 8)(
  input clk,
  input rst,
  input [WIDTH-1:0] din,
  output reg [WIDTH-1:0] dout
);

  always @(posedge clk or posedge rst) begin
    if (rst)
      dout <= 0;
    else
      dout <= dout + din;
  end

endmodule

// Testbench
module accumulator_tb;
  parameter WIDTH = 8;

  reg clk, rst;
  reg [7:0] din;
  wire [7:0] dout;

  accumulator #(8) dut (clk, rst, din, dout);

  initial begin
    clk=0;
    forever #5 clk=~clk;
  end

  initial begin
    rst=1; din=0;
    #20 rst=0;

    repeat(10) begin
      #10 din = $random % 10;
    end

    #100 $finish;
  end

  initial begin
    $monitor("Time = %0t din = %0d dout = %0d", $time, din, dout);
    $dumpfile("acc.vcd");
    $dumpvars;
  end
endmodule
