module moving_avg_8 #(parameter WIDTH = 8)(
  input clk,
  input rst,
  input [WIDTH-1:0] din,
  output reg [WIDTH-1:0] dout
);

  reg [WIDTH-1:0] x[0:7];  // delay line

  integer i;

  // Shift register
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      for (i=0; i<8; i=i+1)
        x[i] <= 0;
    end 
    else begin
      x[7] <= x[6];
      x[6] <= x[5];
      x[5] <= x[4];
      x[4] <= x[3];
      x[3] <= x[2];
      x[2] <= x[1];
      x[1] <= x[0];
      x[0] <= din;
    end
  end

  // Adder process one by one
  wire [WIDTH+3:0] sum1, sum2, sum3, sum4;
  wire [WIDTH+4:0] sum5, sum6;
  wire [WIDTH+5:0] total_sum;

  assign sum1 = x[0] + x[1];
  assign sum2 = x[2] + x[3];
  assign sum3 = x[4] + x[5];
  assign sum4 = x[6] + x[7];

  assign sum5 = sum1 + sum2;
  assign sum6 = sum3 + sum4;

  assign total_sum = sum5 + sum6;

  always @(posedge clk)
    dout <= total_sum >> 3;   

endmodule

// Testbench
module moving_avg_8_tb;

  reg clk, rst;
  reg [7:0] din;
  wire [7:0] dout;

  moving_avg_8 #(8) dut (clk, rst, din, dout);

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
    $dumpfile("avg_filter_8.vcd");
    $dumpvars;
  end
endmodule
