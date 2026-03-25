// Debouncer (switch)
module debounce_switch #(parameter COUNT_MAX = 500000) (
  input clk,
  input rst,
  input noisy_in,
  output reg clean_out
);

  reg [18:0] count;
  reg sync_0, sync_1;

  always @(posedge clk) begin
    sync_0 <= noisy_in;
    sync_1 <= sync_0;
  end

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      count <= 0;
      clean_out <= 0;
    end
    else if (sync_1 != clean_out) begin
      count <= count + 1;
      if (count == COUNT_MAX) begin
        clean_out <= sync_1;
        count <= 0;
      end
    end
    else count <= 0;
  end
endmodule

// Testbench
module debounce_switch_tb;

  reg clk, rst;
  reg noisy_in;
  wire clean_out;

  debounce_switch #(10) DUT (clk,rst,noisy_in,clean_out);

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    rst=1; noisy_in=0;
    #20 rst=0;

    #10 noisy_in=1;
    #10 noisy_in=0;
    #10 noisy_in=1;
    #100;

    #50 noisy_in=0;
    #200 $finish;
  end
  
  initial begin
    $dumpfile("switch.vcd");
    $dumpvars;
  end
endmodule
