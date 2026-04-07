// IIR Filter (2nd order)
module iir_2 #(
  parameter WIDTH=16,
  parameter signed A=1,
  parameter signed B=1,
  parameter signed C=1,
  parameter signed D=1
)(
  input clk,
  input rst,
  input signed [WIDTH-1:0] din,
  output reg signed [2*WIDTH+4:0] dout
);

  reg signed [WIDTH-1:0] x1;
  reg signed [2*WIDTH+4:0] y1,y2;

  always @(posedge clk or posedge rst) begin
    if(rst) begin
      x1<=0; y1<=0; y2<=0; dout<=0;
    end else begin
      dout <= A*din + B*x1 + C*y1 + D*y2;
      x1 <= din;
      y2 <= y1;
      y1 <= dout;
    end
  end

endmodule

// Testbench
module iir_2_tb;

  parameter WIDTH = 16;
  parameter signed A = 2;
  parameter signed B = 1;
  parameter signed C = 1;
  parameter signed D = 1;

  reg clk;
  reg rst;
  reg signed [WIDTH-1:0] din;
  wire signed [2*WIDTH+4:0] dout;


  iir_2 #(.WIDTH(WIDTH),.A(A),.B(B),.C(C),.D(D)) dut (clk, rst, din, dout);

  initial clk = 0;
  always #5 clk = ~clk;

  reg signed [WIDTH-1:0] x1_ref;
  reg signed [2*WIDTH+4:0] y1_ref, y2_ref;
  reg signed [2*WIDTH+4:0] y_ref;

  reg signed [2*WIDTH+4:0] y_ref_d;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      x1_ref <= 0;
      y1_ref <= 0;
      y2_ref <= 0;
      y_ref  <= 0;
    end else begin
      y_ref  <= A*din + B*x1_ref + C*y1_ref + D*y2_ref;
      x1_ref <= din;
      y2_ref <= y1_ref;
      y1_ref <= y_ref;
    end
  end

  always @(posedge clk) begin
    y_ref_d <= y_ref;

    if (!rst) begin
      if (dout !== y_ref_d) begin
        $display("ERROR %0t | din = %0d | Expected = %0d | Got = %0d",
                 $time, din, y_ref_d, dout);
      end else begin
        $display("Time = %0t | din = %0d | dout = %0d",
                 $time, din, dout);
      end
    end
  end

  integer i;

  initial begin
    $display("----- 2nd Order IIR Filter Testbench ------");

    rst = 1;
    din = 0;

    #20 rst = 0;

    // Impulse Test
    $display("Running Impulse Test");
    din = 100;
    @(posedge clk);
    din = 0;
    repeat(15) @(posedge clk);

    // Step Test
    $display("Running Step Test");
    din = 50;
    repeat(20) @(posedge clk);

    // Random Test
    $display("Running Random Test");
    for (i = 0; i < 30; i = i + 1) begin
      din = $random;
      @(posedge clk);
    end

    $display("----- TEST COMPLETE ------");
    $finish;
  end
  
  initial begin
    $dumpfile("iir_2.vcd");
    $dumpvars;
  end

endmodule
