// 8 bit Universal Shift Register
module universal_shift8(
  input clk,rst,
  input [1:0] mode,
  input [7:0] pi,
  input sr,sl,
  output reg [7:0] q
);

  always @(posedge clk or posedge rst) begin
    if(rst)
      q<=0;

    else begin
      case(mode)

        2'b00: q = q;
        2'b01: q = {sr,q[7:1]};
        2'b10: q = {q[6:0],sl};
        2'b11: q = pi;

      endcase
    end
  end

endmodule

// Testbench
module universal_tb;

  reg clk,rst;
  reg [1:0] mode;
  reg [7:0] pi;
  reg sr,sl;
  wire [7:0] q;

  universal_shift8 dut(clk,rst,mode,pi,sr,sl,q);

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    $monitor("Time = %0t Q = %b", $time, q);
    clk = 0; rst = 1;
    #10 rst = 0;

    mode = 2'b11; pi = 8'b10101010; #10;
    mode = 2'b01; sr = 1; #40;
    mode = 2'b10; sl = 0; #40;

    #50 $finish;
  end

endmodule
