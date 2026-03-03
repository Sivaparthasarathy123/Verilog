// D Flip Flop Asynchronous Reset
module d_ff_async_sync_rst (
  input clk,
  input rst,
  input d,
  output reg qsync,
  output reg qasync 
);
  always @(posedge clk or posedge rst) begin
    if (rst)
      qasync <= 0;
    else
      qasync <= d;
  end
   
  always @(posedge clk) begin
    if (rst)
      qsync <= 0;
    else
      qsync <= d;
    
  end
endmodule

// Testbench
module d_ff_async_tb;

  reg clk, rst, d;
  wire qsync, qasync;

  d_ff_async_sync_rst dut (.clk(clk), .rst(rst), .d(d), .qsync(qsync), .qasync(qasync));

  initial clk = 0;  
  always #5 clk = ~clk;

  initial begin
    $monitor("Time = %0t rst = %b d = %b qsync = %b qasync = %b", $time, rst, d, qsync, qasync);
    $dumpfile("wave.vcd");
    $dumpvars;
      rst = 1; d = 0;
      #10 rst = 0; d = 1;
      #12 rst = 1;   // async reset
      #10 rst = 0; d = 0;
      #10 d = 1;
      #20 $finish;
      
  end
endmodule
