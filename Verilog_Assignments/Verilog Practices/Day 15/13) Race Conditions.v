// Race Conditions - Detection and Fix
module race_bad (
  input clk,
  input rst,
  input a,
  input b,
  output reg q
);

  always @(posedge clk) begin
    if (rst)
      q = 1'b0;
    else
      q = a;
  end

  always @(posedge clk) begin
    if (rst)
      q = 1'b0;
    else
      q = b;
  end

endmodule

module race_fixed (
  input clk,
  input rst,
  input sel,
  input a,
  input b,
  output reg q
);

  always @(posedge clk) begin
    if (rst)
      q <= 1'b0;
    else begin
      if (sel)
        q <= a;
      else
        q <= b;
    end
  end

endmodule

// Testbench
module race_condition_tb;

  reg clk;
  reg rst;
  reg sel;
  reg a;
  reg b;

  wire q_bad;
  wire q_fixed;

  race_bad u_bad (
    .clk(clk),
    .rst(rst),
    .a(a),
    .b(b),
    .q(q_bad)
  );

  race_fixed u_fixed (
    .clk(clk),
    .rst(rst),
    .sel(sel),
    .a(a),
    .b(b),
    .q(q_fixed)
  );

  always #5 clk = ~clk;

  initial begin
    $dumpfile("race_condition.vcd");
    $dumpvars;
    $monitor("Time = %0t | clk = %b | rst = %b | sel = %b | a = %b | b = %b | q_bad = %b | q_fixed = %b",$time, clk, rst, sel, a, b, q_bad, q_fixed);
  end

  initial begin
    clk = 0;
    rst = 1;
    sel = 0;
    a   = 0;
    b   = 0;

    #12;
    rst = 0;

    a = 1;
    b = 0;
    sel = 1;   // fixed chooses a
    #10;

    a = 0;
    b = 1;
    sel = 0;   // fixed chooses b
    #10;

    a = 1;
    b = 0;
    sel = 0;   // fixed chooses b
    #10;

    a = 0;
    b = 1;
    sel = 1;   // fixed chooses a
    #10;

    #20;
    $finish;
  end

endmodule
