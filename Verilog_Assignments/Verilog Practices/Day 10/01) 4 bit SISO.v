// 4 bit SISO
module siso_4bit(
  input clk,
  input rst,
  input si,
  output so
);

  reg [3:0] shift;

  always @(posedge clk or posedge rst) begin
    if(rst)
      shift <= 4'b0;
    else
      shift <= {shift[2:0], si};
  end

  assign so = shift[3];

endmodule  

// Testbench
module siso_tb;

  reg clk,rst,si;
  wire so;

  siso_4bit dut(clk,rst,si,so);

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    $monitor("Time = %0t SI = %b SO = %b",$time,si,so);
    rst=1; si=0;
    #10 rst=0;

    si=1; 
    #10 si=0; 
    #10 si=1; 
    #10 si=1;

    #40 $finish;
  end

endmodule
