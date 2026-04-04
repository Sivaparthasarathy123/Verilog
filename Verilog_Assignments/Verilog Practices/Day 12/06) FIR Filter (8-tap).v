// FIR Filter (8-tap)
module fir_8 #(parameter WIDTH = 16)(
  input clk,
  input rst,
  input signed [WIDTH-1:0] din,
  output reg signed [2*WIDTH+4:0] dout
);

  parameter signed H[0:7] = '{1,2,3,4,4,3,2,1};

  reg signed [WIDTH-1:0] x[0:7];
  integer i;

  always @(posedge clk or posedge rst) begin
    if (rst)
      for(i=0;i<8;i=i+1) x[i] <= 0;
    else begin
      for(i=7; i>0; i=i-1)
        x[i] <= x[i-1];
      x[0] <= din;
    end
  end

  reg signed [2*WIDTH+4:0] acc;

  always @(posedge clk or posedge rst) begin
    if (rst)
      dout <= 0;
    else begin
      acc = 0;  
      for(i=0;i<8;i=i+1)
        acc = acc + H[i]*x[i];
      dout <= acc;  
    end
  end

endmodule

// Testbench
module fir8_tb;

  reg clk, rst;
  reg signed [15:0] din;
  wire signed [36:0] dout;

  fir_8 dut(clk,rst,din,dout);

  initial clk = 0;
  always #5 clk=~clk;

  initial begin
    din = 0;
    rst = 1;
    #20 rst=0;
    repeat(20) begin
      din = $random % 20;
      #10;
    end
    #100 $finish;
  end

  initial begin
    $monitor("T = %0t din = %0d dout = %0d",$time,din,dout);
    $dumpfile("fir_8tap.vcd");
    $dumpvars;
  end

endmodule
