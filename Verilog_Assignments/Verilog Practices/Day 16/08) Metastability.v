// Metastability
module cdc_bad (
  input clk_dst,
  input rst_dst,
  input async_in,
  output reg out
);

  always @(posedge clk_dst) begin
    if (rst_dst)
      out <= 1'b0;
    else
      out <= async_in;
  end

endmodule

module cdc_2ff_sync (
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

// Testbench
module metastability_sync_tb;

  reg clk_dst;
  reg rst_dst;
  reg async_in;

  wire bad_out;
  wire sync_out;

  cdc_bad u_bad (
    .clk_dst  (clk_dst),
    .rst_dst  (rst_dst),
    .async_in (async_in),
    .out      (bad_out)
  );

  cdc_2ff_sync u_sync (
    .clk_dst  (clk_dst),
    .rst_dst  (rst_dst),
    .async_in (async_in),
    .sync_out (sync_out)
  );

  always #5 clk_dst = ~clk_dst;

  initial begin
    $dumpfile("metastability_sync.vcd");
    $dumpvars;

    clk_dst  = 0;
    rst_dst  = 1;
    async_in = 0;

    #12;
    rst_dst = 0;

    #2;
    async_in = 1;
    #20;

    #1;
    async_in = 0;

    #9;
    async_in = 1;  
    #1;
    async_in = 0;

    #30;

    // asynchronous change
    #7;
    async_in = 1;

    #40;
    $finish;
  end

  initial begin
    $monitor("Time = %0t | clk_dst = %0b | rst = %0b | async_in = %0b | bad_out = %b | sync_out = %b", $time, clk_dst, rst_dst, async_in, bad_out, sync_out);
  end

endmodule
