// Valid Ready Handshake Protocol
// Producer
module producer (
  input clk,
  input rst,
  input ready,
  output reg  valid,
  output reg [7:0] data
);

  reg [7:0] counter;

  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      counter <= 0;
      valid   <= 0;
    end else begin
      valid <= 1;
      if (valid && ready) begin
        data    <= counter;
        counter <= counter + 1;
      end
    end
  end

endmodule

// Consumer
module consumer (
  input clk,
  input rst,
  input valid,
  input [7:0] data,
  output reg  ready
);

  always @(posedge clk or negedge rst) begin
    if (!rst)
      ready <= 0;
    else
      ready <= $random % 2;
  end

endmodule

// Testbench
module handshake_tb;

  reg clk;
  reg rst;
  wire valid;
  wire ready;
  wire [7:0] data;

  initial clk = 0;
  always #5 clk = ~clk;

  producer p (clk, rst, ready, data, valid);

  consumer c (clk, rst, valid, data, ready);

  initial begin
    $monitor("Time = %0t | clk = %0b | rst = %0b | ready = %0b | data = %0b | valid = %0b",$time,clk,rst,ready,data,valid);
    rst = 0;
    #20 rst = 1;
    #500 $finish;
  end

endmodule
