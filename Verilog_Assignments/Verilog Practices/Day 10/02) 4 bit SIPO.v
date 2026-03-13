// 4 bit SIPO
module sipo_4bit(
  input clk,
  input rst,
  input si,
  output reg [3:0] po
);

  always @(posedge clk or posedge rst) begin
    if(rst)
      po <= 4'b0;
    else
      po <= {po[2:0],si};
  end

endmodule

// Testbench
module sipo_tb;

  reg clk,rst,si;
  wire so;

  sipo_4bit dut(clk,rst,si,po);

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    $monitor("Time = %0t SI = %b PO = %b",$time,si,po);
    rst=1; si=0;
    #10 rst=0;

    si=1; 
    #10 si=0; 
    #10 si=1; 
    #10 si=1;

    #40 $finish;
  end

endmodule
