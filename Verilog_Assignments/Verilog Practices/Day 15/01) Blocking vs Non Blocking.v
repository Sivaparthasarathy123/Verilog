// Blocking vs Non Blocking
module shift_reg_blocking (
  input clk,
  input rst,
  input din,
  output reg q1,
  output reg q2,
  output reg q3
);

  always @(posedge clk) begin
    if (rst) begin
      q1 = 1'b0;
      q2 = 1'b0;
      q3 = 1'b0;
    end
    else begin
      q1 = din;
      q2 = q1;
      q3 = q2;
    end
  end

endmodule

module shift_reg_nonblocking (
  input clk,
  input rst,
  input din,
  output reg q1,
  output reg q2,
  output reg q3
);

  always @(posedge clk) begin
    if (rst) begin
      q1 <= 1'b0;
      q2 <= 1'b0;
      q3 <= 1'b0;
    end
    else begin
      q1 <= din;
      q2 <= q1;
      q3 <= q2;
    end
  end

endmodule

// Testbench
`timescale 1ns/1ps
module assignment_difference_tb;

  reg clk;
  reg rst;
  reg din;

  wire b_q1, b_q2, b_q3;
  wire nb_q1, nb_q2, nb_q3;

  // Wrong design -> blocking assignment
  shift_reg_blocking dut_blocking (
    .clk(clk),
    .rst(rst),
    .din(din),
    .q1(b_q1),
    .q2(b_q2),
    .q3(b_q3)
  );

  // Correct design -> non blocking assignment
  shift_reg_nonblocking dut_nonblocking (
    .clk(clk),
    .rst(rst),
    .din(din),
    .q1(nb_q1),
    .q2(nb_q2),
    .q3(nb_q3)
  );

  always #5 clk = ~clk;

  initial begin
    clk = 0;
    rst = 1;
    din = 0;

    #12;
    rst = 0;

    din = 1; #10;
    din = 0; #10;
    din = 1; #10;
    din = 1; #10;
    din = 0; #10;

    #30;
    $finish;
  end

  initial begin
    $monitor("T = %0t | din = %b | Blocking q1 = %b q2 = %b q3 = %b | NonBlocking q1 = %b q2 = %b q3 = %b",$time, din, b_q1, b_q2, b_q3, nb_q1, nb_q2, nb_q3);
  end

  initial begin
    $dumpfile("assignment_difference.vcd");
    $dumpvars;
  end

endmodule
