// 4 bit PIPO
module pipo_4bit(
  input clk,
  input rst,
  input [3:0] pi,
  output reg [3:0] po
);

  always @(posedge clk or posedge rst) begin
    if(rst)
      po <= 0;
    else
      po <= pi;
  end

endmodule

// Testbench
module pipo_tb;

  reg clk,rst;
  reg [3:0] pi;
  wire [3:0] po;

  pipo_4bit dut(clk,rst,pi,po);

  initial clk = 0;
  always #5 clk=~clk;

  initial begin
    $monitor("Time = %0t PI = %b PO = %b", $time, pi, po);
    rst=1;
    #10 rst=0;

    #10 pi=4'b1010; 
    #10 pi=4'b1111; 
    #10 pi=4'b0001; 

    #40 $finish;
  end

endmodule
