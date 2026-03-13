// 4 bit PISO
module piso_4bit(
  input clk,
  input rst,
  input load,
  input [3:0] pi,
  output so
);

  reg [3:0] shift;

  always @(posedge clk or posedge rst) begin
    if(rst)
      shift <= 0;
    else if(load)
      shift <= pi;
    else
      shift <= {shift[2:0],1'b0};
  end

  assign so = shift[3];

endmodule

// Testbench
module piso_tb;

  reg clk,rst,load;
  reg [3:0] pi;
  wire so;

  piso_4bit dut(clk,rst,load,pi,so);

  initial clk = 0;
  always #5 clk=~clk;

  initial begin
    $monitor("Time = %0t PI = %b SO = %b", $time, pi, so);
    rst=1; load=0;
    #10 rst=0;

    pi=4'b1011;
    #10 load=1;
    #10 load=0;

    #60 $finish;
  end

endmodule
