// Pulse Synchronizer
module pulse_synchronizer (
  input src_clk,
  input src_rst,
  input src_pulse,
  input dst_clk,
  input dst_rst,
  output dst_pulse
);

  reg toggle;

  always @(posedge src_clk or posedge src_rst) begin
    if (src_rst)
      toggle <= 0;
    else if (src_pulse)
      toggle <= ~toggle;
  end

  // 2 FF Synchronizer
  reg sync1, sync2;

  always @(posedge dst_clk or posedge dst_rst) begin
    if (dst_rst) begin
      sync1 <= 0;
      sync2 <= 0;
    end 
    else begin
      sync1 <= toggle;
      sync2 <= sync1;
    end
  end

  assign dst_pulse = sync1 ^ sync2;

endmodule

// Testbench
module pulse_synchronizer_tb;

  reg src_clk, dst_clk;
  reg src_rst, dst_rst;
  reg src_pulse;
  wire dst_pulse;

  pulse_synchronizer dut(src_clk, src_rst, src_pulse, dst_clk, dst_rst, dst_pulse);

  initial begin
    src_clk = 0; dst_clk = 0;
    src_rst = 1; dst_rst = 1;
  end

  always #5  src_clk = ~src_clk;   
  always #7  dst_clk = ~dst_clk;   

  initial begin
    $dumpfile("pulse.vcd");
    $dumpvars;
    #20 src_rst = 0; dst_rst = 0;

    #30 src_pulse = 1;
    #10 src_pulse = 0;

    #100 $finish;
  end

endmodule
