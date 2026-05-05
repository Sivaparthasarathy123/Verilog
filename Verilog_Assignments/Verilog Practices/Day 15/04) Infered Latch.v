// Infered Latch
module latch_infer (
  input en,
  input d,
  output reg q
);

  always @(*) begin
    if (en)
      q = d;
    // missing else
  end

endmodule

module no_latch_mux (
  input en,
  input d,
  output reg q
);

  always @(*) begin
    if (en)
      q = d;
    else
      q = 1'b0;
  end

endmodule

// Testbench
module latch_inference_tb;

  reg en;
  reg d;

  wire q_latch;
  wire q_no_latch;

  latch_infer dut_latch (
    .en(en),
    .d(d),
    .q(q_latch)
  );

  no_latch_mux dut_no_latch (
    .en(en),
    .d(d),
    .q(q_no_latch)
  );

  initial begin
    $dumpfile("latch_inference.vcd");
    $dumpvars;

    $monitor("Time = %t | en = %b | d = %b | latch_q = %b | no_latch_q = %b",
             $time, en, d, q_latch, q_no_latch);

    en = 0; d = 0; #10;

    en = 1; d = 1; #10;   // latch_q = 1
    en = 0; d = 0; #10;   // latch_q holds 1, no_latch_q = 0

    en = 1; d = 0; #10;   // latch_q = 0
    en = 0; d = 1; #10;   // latch_q holds 0, no_latch_q = 0

    en = 1; d = 1; #10;   // latch_q = 1
    en = 0; d = 0; #10;   // latch_q holds 1 again

    #20;
    $finish;
  end

endmodule
