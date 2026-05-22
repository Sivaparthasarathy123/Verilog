// Blocking Assignments in Combinational Logic
module comb_latch_bad (
  input sel,
  input a,
  input b,
  output reg y
);

  always @(*) begin
    if (sel)
      y = a;
    // missing else causes latch
  end

endmodule

module comb_latch_fixed (
  input sel,
  input a,
  input b,
  output reg y
);

  always @(*) begin
    if (sel)
      y = a;
    else
      y = b;
  end

endmodule

module comb_order_bad (
  input a,
  input b,
  input c,
  output reg x,
  output reg y
);

  always @(*) begin
    y = x & c;   // uses previous x
    x = a | b;
  end

endmodule

module comb_order_fixed (
  input a,
  input b,
  input c,
  output reg x,
  output reg y
);

  always @(*) begin
    x = a | b;
    y = x & c;
  end

endmodule

// Testbench
module blocking_comb;

  reg sel;
  reg a, b, c;

  wire y_latch_bad;
  wire y_latch_fixed;

  wire x_order_bad;
  wire y_order_bad;

  wire x_order_fixed;
  wire y_order_fixed;

  comb_latch_bad u_latch_bad (
    .sel(sel),
    .a(a),
    .b(b),
    .y(y_latch_bad)
  );

  comb_latch_fixed u_latch_fixed (
    .sel(sel),
    .a(a),
    .b(b),
    .y(y_latch_fixed)
  );

  comb_order_bad u_order_bad (
    .a(a),
    .b(b),
    .c(c),
    .x(x_order_bad),
    .y(y_order_bad)
  );

  comb_order_fixed u_order_fixed (
    .a(a),
    .b(b),
    .c(c),
    .x(x_order_fixed),
    .y(y_order_fixed)
  );

  initial begin
    $dumpfile("blocking_comb.vcd");
    $dumpvars;

    $display("Latch problem test");
    $display("------------------------------------------------------------");

    sel = 0; a = 0; b = 0; c = 0; #10;
    show_latch();

    sel = 1; a = 1; b = 0; c = 0; #10;
    show_latch();

    sel = 0; a = 0; b = 0; c = 0; #10;
    show_latch();

    sel = 1; a = 0; b = 1; c = 0; #10;
    show_latch();

    sel = 0; a = 1; b = 1; c = 0; #10;
    show_latch();

    $display("Statement order problem test");
    $display("------------------------------------------------------------");
    a = 0; b = 0; c = 1; #10;
    show_order();

    a = 1; b = 0; c = 1; #10;
    show_order();

    a = 0; b = 0; c = 1; #10;
    show_order();

    a = 0; b = 1; c = 1; #10;
    show_order();

    a = 0; b = 0; c = 1; #10;
    show_order();

    #20;
    $finish;
  end

  task show_latch;
    begin
      $display("Time = %0t | sel = %b a = %b b = %b | latch_bad = %b | latch_fixed = %b",n$time, sel, a, b, y_latch_bad, y_latch_fixed);
    end
  endtask

  task show_order;
    begin
      $display("Time = %0t | a = %b b = %b c = %b | bad_x = %b | bad_y = %b | fixed_x = %b fixed_y = %b",$time, a, b, c, x_order_bad, y_order_bad, x_order_fixed, y_order_fixed);
    end
  endtask

endmodule
