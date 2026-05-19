// Function vs Task - When to Use Which
module task_example;

  reg clk;
  reg start;

  initial begin
    clk = 0;
    start = 0;
  end

  always #5 clk = ~clk;

  task pulse_start;
    begin
      @(posedge clk);
      start = 1'b1;
      @(posedge clk);
      start = 1'b0;
    end
  endtask

endmodule

module function_example (
  input [3:0] a,
  input [3:0] b,
  output [4:0] sum
);

  function [4:0] add_func;
    input [3:0] x;
    input [3:0] y;
    begin
      add_func = x + y;
    end
  endfunction

  assign sum = add_func(a, b);

endmodule

// Testbench
module function_vs_task;

  reg  [3:0] a;
  reg  [3:0] b;
  wire [4:0] sum;

  reg clk;
  reg start;

  function_example dut (
    .a(a),
    .b(b),
    .sum(sum)
  );

  always #5 clk = ~clk;

  function [4:0] expected_add;
    input [3:0] x;
    input [3:0] y;
    begin
      expected_add = x + y;
    end
  endfunction

  task apply_inputs;
    input [3:0] ta;
    input [3:0] tb;
    begin
      @(posedge clk);
      a = ta;
      b = tb;
      start = 1'b1;

      @(posedge clk);
      start = 1'b0;

      #1;
      check_result();
    end
  endtask

  // Task to check result
  task check_result;
    reg [4:0] expected;
    begin
      expected = expected_add(a, b);

      $display("Time = %0t | a = %0d b = %0d | sum = %0d expected = %0d | start = %b",$time, a, b, sum, expected, start);

      if (sum == expected)
        $display("PASS");
      else
        $display("FAIL");
    end
  endtask

  initial begin
    $dumpfile("function_vs_task.vcd");
    $dumpvars;

    clk = 0;
    start = 0;
    a = 0;
    b = 0;

    apply_inputs(4'd3,  4'd4);
    apply_inputs(4'd7,  4'd8);
    apply_inputs(4'd15, 4'd1);
    apply_inputs(4'd10, 4'd5);

    #20;
    $finish;
  end

endmodule
