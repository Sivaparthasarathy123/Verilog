// Clock Domain Crossing
module bit_sync_2ff (
  input clk_dst,
  input rst_dst,
  input async_in,
  output sync_out
);

  reg sync_ff1;
  reg sync_ff2;

  always @(posedge clk_dst) begin
    if (rst_dst) begin
      sync_ff1 <= 1'b0;
      sync_ff2 <= 1'b0;
    end
    else begin
      sync_ff1 <= async_in;
      sync_ff2 <= sync_ff1;
    end
  end

  assign sync_out = sync_ff2;

endmodule

module pulse_sync_fast_to_slow (
  input clk_fast,
  input rst_fast,
  input pulse_fast,

  input clk_slow,
  input rst_slow,
  output pulse_slow
);

  reg toggle_fast;

  always @(posedge clk_fast) begin
    if (rst_fast)
      toggle_fast <= 1'b0;
    else if (pulse_fast)
      toggle_fast <= ~toggle_fast;
  end

  reg sync1_slow;
  reg sync2_slow;
  reg sync3_slow;

  always @(posedge clk_slow) begin
    if (rst_slow) begin
      sync1_slow <= 1'b0;
      sync2_slow <= 1'b0;
      sync3_slow <= 1'b0;
    end
    else begin
      sync1_slow <= toggle_fast;
      sync2_slow <= sync1_slow;
      sync3_slow <= sync2_slow;
    end
  end

  assign pulse_slow = sync2_slow ^ sync3_slow;

endmodule

// Testbench
module pulse_sync_fast_to_slow_tb;

  reg clk_fast;
  reg clk_slow;
  reg rst_fast;
  reg rst_slow;
  reg pulse_fast;

  wire pulse_slow;

  pulse_sync_fast_to_slow dut (
    .clk_fast   (clk_fast),
    .rst_fast   (rst_fast),
    .pulse_fast (pulse_fast),
    .clk_slow   (clk_slow),
    .rst_slow   (rst_slow),
    .pulse_slow (pulse_slow)
  );

  // Fast Clock
  always #5 clk_fast = ~clk_fast;

  // Slow Clock
  always #20 clk_slow = ~clk_slow;

  initial begin
    $dumpfile("pulse_sync_fast_to_slow.vcd");
    $dumpvars;

    clk_fast   = 0;
    clk_slow   = 0;
    rst_fast   = 1;
    rst_slow   = 1;
    pulse_fast = 0;

    #50;
    rst_fast = 0;
    rst_slow = 0;

    send_fast_pulse();
    #100;

    send_fast_pulse();
    #120;

    send_fast_pulse();
    #150;

    $finish;
  end

  task send_fast_pulse;
    begin
      @(posedge clk_fast);
      pulse_fast = 1'b1;

      @(posedge clk_fast);
      pulse_fast = 1'b0;
    end
  endtask

  initial begin
    $monitor("Time = %0t | pulse_fast = %b | pulse_slow = %b",$time, pulse_fast, pulse_slow);
  end

endmodule
