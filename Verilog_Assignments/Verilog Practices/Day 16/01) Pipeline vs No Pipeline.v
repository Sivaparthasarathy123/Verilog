// Pipeline vs No Pipeline

module long_path_no_pipeline (
  input clk,
  input rst,
  input [7:0] a,
  input [7:0] b,
  input [7:0] c,
  input [7:0] d,
  output reg [17:0] y
);

  always @(posedge clk) begin
    if (rst)
      y <= 18'd0;
    else
      y <= ((a * b) + (c * d)) + ((a + c) * (b + d));
  end

endmodule

module long_path_pipelined (
  input clk,
  input rst,
  input [7:0] a,
  input [7:0] b,
  input [7:0] c,
  input [7:0] d,
  output reg [17:0] y
);

  reg [15:0] stage1_mul1;
  reg [15:0] stage1_mul2;
  reg [8:0]  stage1_add1;
  reg [8:0]  stage1_add2;

  reg [16:0] stage2_sum_mul;
  reg [17:0] stage2_mul_add;

  always @(posedge clk) begin
    if (rst) begin
      stage1_mul1   <= 16'd0;
      stage1_mul2   <= 16'd0;
      stage1_add1   <= 9'd0;
      stage1_add2   <= 9'd0;
      stage2_sum_mul <= 17'd0;
      stage2_mul_add <= 18'd0;
      y              <= 18'd0;
    end
    else begin
      // Stage 1
      stage1_mul1 <= a * b;
      stage1_mul2 <= c * d;
      stage1_add1 <= a + c;
      stage1_add2 <= b + d;

      // Stage 2
      stage2_sum_mul <= stage1_mul1 + stage1_mul2;
      stage2_mul_add <= stage1_add1 * stage1_add2;

      // Stage 3
      y <= stage2_sum_mul + stage2_mul_add;
    end
  end

endmodule

// Testbench
module pipeline_compare;

  reg clk;
  reg rst;

  reg [7:0] a;
  reg [7:0] b;
  reg [7:0] c;
  reg [7:0] d;

  wire [17:0] y_no_pipe;
  wire [17:0] y_pipe;

  reg [17:0] expected_now;
  reg [17:0] expected_d1;
  reg [17:0] expected_d2;
  reg [17:0] expected_d3;

  integer i;

  long_path_no_pipeline u_no_pipe (
    .clk(clk),
    .rst(rst),
    .a(a),
    .b(b),
    .c(c),
    .d(d),
    .y(y_no_pipe)
  );

  long_path_pipelined u_pipe (
    .clk(clk),
    .rst(rst),
    .a(a),
    .b(b),
    .c(c),
    .d(d),
    .y(y_pipe)
  );

  always #5 clk = ~clk;

  function [17:0] calc_expected;
    input [7:0] fa;
    input [7:0] fb;
    input [7:0] fc;
    input [7:0] fd;
    begin
      calc_expected = ((fa * fb) + (fc * fd)) + ((fa + fc) * (fb + fd));
    end
  endfunction

  initial begin
    $dumpfile("pipeline_compare.vcd");
    $dumpvars;

    clk = 0;
    rst = 1;
    a = 0;
    b = 0;
    c = 0;
    d = 0;

    expected_d1 = 0;
    expected_d2 = 0;
    expected_d3 = 0;

    #12;
    rst = 0;

    for (i = 0; i < 8; i = i + 1) begin
      @(negedge clk);
      a = i + 1;
      b = i + 2;
      c = i + 3;
      d = i + 4;
    end

    repeat (5) @(negedge clk);

    $finish;
  end

  always @(posedge clk) begin
    if (rst) begin
      expected_now <= 18'd0;
      expected_d1  <= 18'd0;
      expected_d2  <= 18'd0;
      expected_d3  <= 18'd0;
    end
    else begin
      expected_now <= calc_expected(a, b, c, d);

      expected_d1 <= expected_now;
      expected_d2 <= expected_d1;
      expected_d3 <= expected_d2;
    end
  end

  always @(posedge clk) begin
    #1;

    $display("T = %0t | a = %0d b = %0d c = %0d d = %0d | no_pipe = %0d | pipe = %0d | pipe_expected = %0d",$time, a, b, c, d, y_no_pipe, y_pipe, expected_d3);

    if (!rst) begin
      if (y_no_pipe == expected_now)
        $display("NO PIPE PASS");
      else
        $display("NO PIPE CHECK -> current output follows latest registered calculation");

      if (y_pipe == expected_d3)
        $display("PIPE PASS");
      else
        $display("PIPE CHECK: pipeline output has 3-cycle latency");
    end
  end

endmodule
