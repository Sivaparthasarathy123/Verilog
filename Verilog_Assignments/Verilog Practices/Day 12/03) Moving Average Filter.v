// Moving Average Filter (4-tap)
module moving_avg_4 #(parameter WIDTH = 8)(
  input clk,
  input rst,
  input [WIDTH-1:0] din,
  output reg [WIDTH-1:0] dout
);

  reg [WIDTH-1:0] x0,x1,x2,x3;
  wire [WIDTH+1:0] sum;

  assign sum = x0 + x1 + x2 + x3;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      x0<=0; x1<=0; x2<=0; x3<=0;
    end 
    else begin
      x3 <= x2;
      x2 <= x1;
      x1 <= x0;
      x0 <= din;
    end
  end

  always @(posedge clk)
    dout <= sum >> 2;   // divide by 4

endmodule

// Testbench
module moving_avg_4_tb;

  reg clk, rst;
  reg [7:0] din;
  wire [7:0] dout;

  moving_avg_4 #(8) dut (clk, rst, din, dout);

  initial begin
    clk=0;
    forever #5 clk=~clk;
  end

  initial begin
    rst = 1; din = 0;
    #20 rst = 0;

    #10 din = 10; 
    #10 din = 20; 
    #10 din = 30; 
    #10 din = 40; 
    #10 din = 50; 

    #100 $finish;
  end

  initial begin
    $monitor("T = %0t din = %0d dout = %0d", $time, din, dout);
    $dumpfile("avg_filter.vcd");
    $dumpvars;
  end
endmodule
