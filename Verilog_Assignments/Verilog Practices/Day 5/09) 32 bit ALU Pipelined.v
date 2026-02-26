// 32 bit ALU (pipelined)
module alu_32bit_pipeline(
  input clk,
  input [31:0] A,B,
  input [1:0] sel,
  output reg [31:0] Y
);

  reg [31:0] stage1_A, stage1_B;
  reg [1:0] stage1_sel;
  reg [31:0] stage2_Y;

  always @(posedge clk) begin
    stage1_A <= A;
    stage1_B <= B;
    stage1_sel <= sel;
  end

  always @(posedge clk) begin
    case(stage1_sel)
        2'b00: stage2_Y <= stage1_A + stage1_B;
        2'b01: stage2_Y <= stage1_A - stage1_B;
        default: stage2_Y <= 0;
    endcase
  end

  always @(posedge clk)
    Y <= stage2_Y;

endmodule

// Testbench
module alu_32bit_pipeline_tb;

  reg clk;
  reg [31:0] A,B;
  reg [1:0] sel;
  wire [31:0] Y;

  alu_32bit_pipeline dut (clk,A,B,sel,Y);

  // Clock generation
  always #5 clk = ~clk;

  initial begin
    clk = 0;
    $monitor("Time = %0t A = %0d B = %0d SEL = %0b Y = %0d",$time,A,B,sel,Y);

    A = 32'd100; B = 32'd20; sel = 2'b00; #20; // ADD
    sel = 2'b01; #20;                          // SUB

    A = 32'd500; B = 32'd100; sel = 2'b00; #20;

    $finish;
  end

endmodule
