// Glitch Filter
module glitch_filter #(
  parameter FILTER_LEN = 4
)(
  input clk,
  input rst,
  input noisy_in,
  output reg  clean_out
);

  reg [$clog2(FILTER_LEN):0] count;
  reg sync_1, sync_2;

  // 2-FF Synchronizer
  always @(posedge clk) begin
    sync_1 <= noisy_in;
    sync_2 <= sync_1;
  end

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      count     <= 0;
      clean_out <= 0;
    end 
    else begin
      if (sync_2 == clean_out) begin
        count <= 0;
      end 
      else begin
        count <= count + 1;

        if (count == FILTER_LEN-1) begin
          clean_out <= sync_2;
          count <= 0;
        end
      end
    end
  end

endmodule

// Testbench
module glitch_filter_tb;

  reg clk;
  reg rst;
  reg noisy_in;
  wire clean_out;

  glitch_filter #(.FILTER_LEN(4)) DUT (clk, rst, noisy_in, clean_out);

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    rst = 1;
    noisy_in = 0;
    #20 rst = 0;

    #30 noisy_in = 1;
    #10 noisy_in = 0;

    // Valid pulse
    #100 noisy_in = 1;
    #100 noisy_in = 0;

    #300;
    $finish;
  end

endmodule
