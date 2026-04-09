// Square root calculator
module sqrt_calc #(
  parameter WIDTH = 16
)(
  input clk,
  input rst,
  input start,
  input [WIDTH-1:0]din,
  output reg busy,
  output reg done,
  output reg [WIDTH/2-1:0] root
);

  localparam ITER = WIDTH/2;

  reg [WIDTH-1:0] radicand;
  reg [WIDTH+1:0] remainder;
  reg [WIDTH/2:0] root_work;
  reg [$clog2(ITER+1)-1:0] count;

  reg [WIDTH+1:0] rem_next;
  reg [WIDTH+1:0] trial;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      busy      <= 1'b0;
      done      <= 1'b0;
      root      <= {WIDTH/2{1'b0}};
      radicand  <= {WIDTH{1'b0}};
      remainder <= {(WIDTH+2){1'b0}};
      root_work <= {(WIDTH/2+1){1'b0}};
      count     <= {($clog2(ITER+1)){1'b0}};
    end
    else begin
      done <= 1'b0;

      if (start && !busy) begin
        busy      <= 1'b1;
        radicand  <= din;
        remainder <= {(WIDTH+2){1'b0}};
        root_work <= {(WIDTH/2+1){1'b0}};
        count     <= ITER[$clog2(ITER+1)-1:0];
      end
      else if (busy) begin
        rem_next = {remainder[WIDTH-1:0], radicand[WIDTH-1:WIDTH-2]};
        trial    = { {(WIDTH-(WIDTH/2)){1'b0}}, root_work, 1'b1 };

        radicand <= radicand << 2;

        if (rem_next >= trial) begin
          remainder <= rem_next - trial;
          root_work <= {root_work[WIDTH/2-1:0], 1'b1};
        end
        else begin
          remainder <= rem_next;
          root_work <= {root_work[WIDTH/2-1:0], 1'b0};
        end

        if (count == 1) begin
          busy <= 1'b0;
          done <= 1'b1;
          root <= {root_work[WIDTH/2-1:0], (rem_next >= trial)};
        end

        count <= count - 1'b1;
      end
    end
  end

endmodule

// Testbench
`timescale 1ns/1ps

module sqrt_calc_tb;

  parameter WIDTH = 16;

  reg clk;
  reg rst;
  reg start;
  reg [WIDTH-1:0] din;
  wire busy;
  wire done;
  wire [WIDTH/2-1:0] root;

  integer i;
  integer errors;
  integer expected;

  sqrt_calc #(.WIDTH(WIDTH)) dut (clk, rst, start, din, busy, done, root);

  initial clk = 0;
  always #5 clk = ~clk;

  function integer isqrt;
    input integer val;
    integer r;
    begin
      r = 0;
      while ((r+1)*(r+1) <= val)
        r = r + 1;
      isqrt = r;
    end
  endfunction

  task run_case;
    input [WIDTH-1:0] val;
    begin
      @(negedge clk);
      din   = val;
      start = 1'b1;
      @(negedge clk);
      start = 1'b0;

      wait(done == 1'b1);
      @(posedge clk);

      expected = isqrt(val);

      if (root !== expected[WIDTH/2-1:0]) begin
        $display("ERROR => din = %0d expected = %0d got = %0d", val, expected, root);
        errors = errors + 1;
      end
      else begin
        $display("PASS => din = %0d root = %0d", val, root);
      end
    end
  endtask

  initial begin
    clk = 0;
    rst = 1;
    start = 0;
    din = 0;
    errors = 0;

    #20 rst = 0;

    run_case(0);
    run_case(1);
    run_case(2);
    run_case(3);
    run_case(4);
    run_case(15);
    run_case(16);
    run_case(17);


    for (i = 0; i < 20; i = i + 1)
      run_case($random);

    if (errors == 0)
      $display("ALL SQRT TESTS PASSED");
    else
      $display("SQRT TEST FAILED, errors = %0d", errors);

    #20 $finish;
  end
  initial begin
    $dumpfile("sqrt_calc.vcd");
    $dumpvars;
  end

endmodule
