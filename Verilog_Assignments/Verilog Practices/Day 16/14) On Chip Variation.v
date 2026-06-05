// On Chip Variation
module ocv_demo (
  input clk,
  input [7:0] a,
  input [7:0] b,
  output reg [15:0] y
);

  wire [15:0] mult;

  assign mult = a * b;

  always @(posedge clk) begin
    y <= mult;
  end

endmodule

// Testbench
module ocv_demo_tb;

  reg clk;
  reg [7:0] a;
  reg [7:0] b;

  wire [15:0] y;

  ocv_demo dut (clk, a, b, y));

  always #5 clk = ~clk;

  initial begin
    clk = 0;
    a   = 0;
    b   = 0;

    #10;
    a = 10;
    b = 5;

    #10;
    a = 20;
    b = 3;

    #10;
    a = 8;
    b = 8;

    #20;
    $finish;
  end

  initial begin
    $monitor("T = %0t a = %d b = %d y = %d",$time,a,b,y);
  end

endmodule
