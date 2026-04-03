// FIR Filter (4-tap)
module fir_4 #
  (
    parameter WIDTH = 16,
    parameter signed H0 = 1,
    parameter signed H1 = 2,
    parameter signed H2 = 2,
    parameter signed H3 = 1
  )
  (
    input clk,
    input rst,
    input signed [WIDTH-1:0] din,
    output reg signed [2*WIDTH+2:0] dout
  );

  reg signed [WIDTH-1:0] x0,x1,x2,x3;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      x0<=0; x1<=0; x2<=0; x3<=0;
    end 
    else begin
      x3<=x2;
      x2<=x1;
      x1<=x0;
      x0<=din;
    end
  end

  always @(posedge clk)
    dout <= H0*x0 + H1*x1 + H2*x2 + H3*x3;

endmodule

// Testbench
module tb_fir4;

  reg clk, rst;
  reg signed [15:0] din;
  wire signed [34:0] dout;

  fir_4 dut(clk,rst,din,dout);

  initial clk = 0;
  always #5 clk=~clk;

  initial begin
    rst = 1;
    #20 rst=0;

    #10 din=1;
    #10 din=2;
    #10 din=3;
    #10 din=4;
    #10 din=5;

    #100 $finish;
  end

  initial begin
    $monitor("T = %0t din = %0d dout = %0d",$time,din,dout);
    $dumpfile("fir.vcd");
    $dumpvars;
  end
endmodule
