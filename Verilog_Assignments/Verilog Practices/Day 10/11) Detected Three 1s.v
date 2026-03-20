// Detect Three 1s without FSM
module detect_three_ones (
  input clk,
  input rst,
  input din,
  output reg  detected
);

  reg [2:0] shift_reg;

  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      shift_reg <= 3'b000;
      detected  <= 0;
    end 
    else begin
      shift_reg <= {shift_reg[1:0], din};
      detected  <= (shift_reg == 3'b111);
    end
  end

endmodule

// Testbench
module detect_three_tb;

  reg clk;
  reg rst;
  reg din;
  wire detected;

  initial clk = 0;
  always #5 clk = ~clk;

  detect_three_ones dut (clk, rst, din, detected);

  initial begin
    $monitor("Time = %0t | clk = %0b | rst = %0b | din = %0b | detected = %0b",$time,clk,rst,din,detected);
    rst = 0;
    din = 0;
    #20 rst = 1;

    #10 din = 1; 
    #10 din = 1;
    #10 din = 1; 
    #10 din = 0; 

    $finish;
  end

endmodule
