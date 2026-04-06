// IIR Filter (1st order)
module iir_1 #(
  parameter WIDTH = 16,
  parameter signed A = 1,
  parameter signed B = 1
)(
  input clk,
  input rst,
  input signed [WIDTH-1:0] din,
  output reg signed [2*WIDTH+2:0] dout
);

  reg signed [2*WIDTH+2:0] y_prev;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      dout <= 0;
      y_prev <= 0;
    end 
    else begin
      dout <= A*din + B*y_prev;
      y_prev <= dout;
    end
  end

endmodule

// Testbench
module iir_1_tb;

  parameter WIDTH = 16;
  parameter signed A = 2; 
  parameter signed B = 1;

  reg clk;
  reg rst;
  reg signed [WIDTH-1:0] din;
  wire signed [2*WIDTH+2:0] dout;

  iir_1 #(.WIDTH(WIDTH), .A(A), .B(B)) dut (clk, rst, din, dout);

  initial clk = 0;
  always #5 clk = ~clk;

  reg signed [2*WIDTH+2:0] y_ref;
  reg signed [2*WIDTH+2:0] y_prev_ref;

  integer i;

  initial begin
    $display("----- IIR 1st Order Filter Testbench -----");

    rst = 1;
    din = 0;
    y_ref = 0;
    y_prev_ref = 0;

    #20 rst = 0;

    $display("Running Impulse Test");
    din = 100;
    @(posedge clk);
    din = 0;

    repeat (10) @(posedge clk);

    $display("Running Step Test");
    din = 50;
    repeat (15) @(posedge clk);

    $display("Running Random Test");
    for (i = 0; i < 20; i = i + 1) begin
      din = $random;
      @(posedge clk);
    end

    $display("Test Completed");
    $finish;
  end

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      y_ref      <= 0;
      y_prev_ref <= 0;
    end 
    else begin
      y_ref      <= A*din + B*y_prev_ref;
      y_prev_ref <= y_ref;
    end
  end

  reg signed [2*WIDTH+2:0] y_ref_d;

  always @(posedge clk) begin
    y_ref_d <= y_ref;

    if (!rst) begin
      if (dout !== y_ref_d) begin
        $display("ERROR = %0t din = %0d Expected = %0d Got = %0d",$time, din, y_ref_d, dout);
      end
      else begin
        $display("Time = %0t din = %0d dout = %0d",$time, din, dout);
      end
    end
  end

  initial begin
    $dumpfile("iir_1.vcd");
    $dumpvars;
  end

endmodule
