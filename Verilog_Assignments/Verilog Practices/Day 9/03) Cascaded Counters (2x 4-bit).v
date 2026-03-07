// Cascaded Counters (2x 4-bit)
module cascaded_counter(
  input clk,
  input rst,
  output reg [3:0] count1,
  output reg [3:0] count2
);

  always @(posedge clk) begin
    if(rst) begin
      count1 <= 0;
      count2 <= 0;
    end
    else begin
      count1 <= count1 + 1;

      if(count1 == 4'b1111)
        count2 <= count2 + 1;
    end
  end

endmodule 

// Testbench
module cascaded_counter_tb;
  reg clk, rst;
  wire [3:0] count1; 
  wire [3:0] count2;

  cascaded_counter dut(clk, rst, count1, count2);

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    $monitor("Time = %0t clk = %0b rst = %0b count1 = %0b count2 = %0b",$time,clk,rst,count1,count2);

    rst = 1;
    #50 rst = 0;

    #10000 $finish;
  end
endmodule
