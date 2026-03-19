// Debounce Circuit
module debounce #(
  parameter COUNT_MAX = 100000   
)(
  input  wire clk,
  input  wire rst,
  input  wire noise,
  output reg  clean_out
);

  // 2-flop synchronizer
  reg sync_0, sync_1;

  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      sync_0 <= 0;
      sync_1 <= 0;
    end 
    else begin
      sync_0 <= noise;
      sync_1 <= sync_0;
    end
  end

  reg [$clog2(COUNT_MAX):0] counter;

  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      counter   <= 0;
      clean_out <= 0;
    end 
    else begin
      if (sync_1 == clean_out)
        counter <= 0;
      else begin
        if (counter == COUNT_MAX) begin
          clean_out <= sync_1;
          counter   <= 0;
        end else
          counter <= counter + 1;
      end
    end
  end

endmodule

// Testbench
module debounce_tb;
  reg clk = 0;
  reg rst;
  reg noise;
  wire clean_out;

  initial clk = 0;
  always #5 clk = ~clk;

  debounce #(.COUNT_MAX(5)) dut (clk, rst, noise, clean_out);

  initial begin
    $monitor("Time = %0t | clk = %0b | rst = %0b | noise = %0b | clean_out = %0b",$time,clk,rst,noise,clean_out);
    rst = 0;
    noise = 0;
    #20 rst = 1;

    #10 noise = 1;
    #10 noise = 0;
    #10 noise = 1;
    #10 noise = 0;
    #10 noise = 1;

    #200 $finish;
  end

endmodule
