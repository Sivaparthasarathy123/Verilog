// Static Timing Analysis
module sta_timing_paths (
  input clk,
  input rst,
  input in_a,
  input in_b,
  input enable,
  output out_comb,
  output out_reg_comb,
  output reg reg1,
  output reg reg2
);

  // Input to register
  always @(posedge clk) begin
    if (rst)
      reg1 <= 1'b0;
    else
      reg1 <= (in_a & in_b) | enable;
  end

  // register to register
  always @(posedge clk) begin
    if (rst)
      reg2 <= 1'b0;
    else
      reg2 <= reg1 ^ enable;
  end

  // register to output
  assign out_reg_comb = reg2 & enable;

  // input to output
  assign out_comb = in_a | in_b;

endmodule

// Testbench
module sta_timing_paths_tb;

  reg clk;
  reg rst;
  reg in_a;
  reg in_b;
  reg enable;

  wire out_comb;
  wire out_reg_comb;
  wire reg1;
  wire reg2;

  sta_timing_paths dut (
    .clk(clk),
    .rst(rst),
    .in_a(in_a),
    .in_b(in_b),
    .enable(enable),
    .out_comb(out_comb),
    .out_reg_comb(out_reg_comb),
    .reg1(reg1),
    .reg2(reg2)
  );

  always #5 clk = ~clk;

  initial begin
    $dumpfile("sta_timing_paths.vcd");
    $dumpvars;

    clk = 0;
    rst = 1;
    in_a = 0;
    in_b = 0;
    enable = 0;

    #12;
    rst = 0;

    // input to output
    in_a = 1;
    in_b = 0;
    enable = 0;
    #10;

    // input to register
    in_a = 1;
    in_b = 1;
    enable = 0;
    #10;

    // register to register
    enable = 1;
    #10;

    in_a = 0;
    in_b = 1;
    enable = 1;
    #10;

    enable = 0;
    #20;

    $finish;
  end

  initial begin
    $monitor("Time = %0t | in_a = %b | in_b = %b | enable = %b | reg1 = %b  reg2 = %b | out_comb = %b | out_reg_comb = %b",$time, in_a, in_b, enable, reg1, reg2, out_comb, out_reg_comb);
  end

endmodule
