// Digital Stopwatch
module digital_stopwatch #(
  parameter CLK_FREQ = 50_000_000)(
  input clk,
  input rst,
  input start,
  input stop,
  input rst_btn,
  output reg [9:0]msec_out,
  output reg [5:0]sec_out
);

  localparam MS_COUNT = CLK_FREQ/1000;

  reg [31:0]clk_count;
  reg tick_1ms;
  reg counting;

  always @(posedge clk or posedge rst) begin
    if(rst)begin
      clk_count <= 0;
      tick_1ms  <= 0;
    end
    else begin
      if(clk_count == MS_COUNT-1) begin
        clk_count <= 0;
        tick_1ms  <= 1;
      end
      else begin
        clk_count <= clk_count + 1;
        tick_1ms  <= 0;
      end
    end
  end

  // Three controls
  always @(posedge clk or posedge rst) begin
    if(rst)
      counting <= 0;
    else if(start)
      counting <= 1;
    else if(stop)
      counting <= 0;
    else if(rst_btn)
      counting <= 0;
  end

  // Counting Logic
  always @(posedge clk or posedge rst) begin
    if(rst || rst_btn)begin
      msec_out <= 0;
      sec_out  <= 0;
    end
    else if(counting && tick_1ms)begin
      if(msec_out == 999)begin
        msec_out <= 0;
        if(sec_out == 59)
          sec_out <= 0;
        else
          sec_out <= sec_out + 1;
      end
      else
        msec_out <= msec_out + 1;
    end
  end

endmodule

// testbench
module digital_stopwatch_tb;

  parameter CLK_FREQ = 1000;

  reg clk;
  reg rst;
  reg start;
  reg stop;
  reg rst_btn;
  wire [9:0]msec_out;
  wire [5:0]sec_out;

   digital_stopwatch #(.CLK_FREQ(CLK_FREQ))dut (.clk(clk),.rst(rst),.start(start),.stop(stop),.rst_btn(rst_btn),.msec_out(msec_out),.sec_out(sec_out));

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    $monitor("Time = %0t | clk = %b | rst = %d | start = %d | stop = %d | rst_btn = %d | msec_out = %d | sec_out = %d", $time, clk, rst, start, stop, rst_btn, msec_out, sec_out);

    $dumpfile("stopwatch.vcd");
    $dumpvars;

    rst     = 1;
    start   = 0;
    stop    = 0;
    rst_btn = 0;

    #20;
    rst = 0;

    // Start stopwatch
    #20;
    start = 1;
    #10;
    start = 0;
    // Stopwatch runnning
    #200;

//     // Stop stopwatch
//     stop = 1;
//     #10;
//     stop = 0;

    // Waiting
    #100;

    // Reset button
//     rst_btn = 1;
//     #10;
//     rst_btn = 0;

    #100000;

    $finish;
  end
endmodule
