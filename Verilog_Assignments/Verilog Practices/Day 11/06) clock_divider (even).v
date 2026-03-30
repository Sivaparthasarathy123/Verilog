// Clock Divider (even)
module clk_div_even #(
  parameter DIVIDE = 4
)(
  input clk,
  input rst,
  output reg  clk_out
);

  localparam HALF_DIV = DIVIDE/2;

  reg [$clog2(HALF_DIV)-1:0] count;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      count   <= 0;
      clk_out <= 0;
    end 
    else begin
      if (count == HALF_DIV - 1) begin
        count   <= 0;
        clk_out <= ~clk_out;
      end 
      else begin
        count <= count + 1;
      end
    end
  end

endmodule

// Testbench
module clk_div_even_tb;

  reg clk;
  reg rst;
  wire clk_out;

  parameter DIVIDE = 4;

  clk_div_even #(.DIVIDE(DIVIDE)) dut (clk, rst, clk_out);

  initial clk = 0;  
  always #5 clk = ~clk;  

  initial begin
    rst = 1;
    #20;
    rst = 0;

    #500;
    $finish;
  end

  initial begin
    $monitor("clk = %0b | rst = %0b | clk_out = %0b",clk, rst, clk_out);
    $dumpfile("cd_even.vcd");
    $dumpvars;
  end

endmodule
