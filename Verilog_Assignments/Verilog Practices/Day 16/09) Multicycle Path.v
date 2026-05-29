// Multicycle Path
module multicycle_path_demo (
  input clk,
  input rst,
  input start,
  input [7:0] a,
  input [7:0] b,
  output reg done,
  output reg [15:0] result
);

  reg [1:0] cycle_cnt;

  always @(posedge clk) begin
    if(rst)begin
      cycle_cnt <= 0;
      done      <= 0;
      result    <= 0;
    end
    else begin
      done <= 0;
      if(start)
        cycle_cnt <= 2;
      else if(cycle_cnt != 0)
        cycle_cnt <= cycle_cnt - 1;
      if(cycle_cnt == 1) begin
        result <= a * b;
        done   <= 1;
      end
    end
  end

endmodule

// Testbench
module multicycle_path_demo_tb;

  reg clk;
  reg rst;
  reg start;
  reg [7:0] a;
  reg [7:0] b;

  wire done;
  wire [15:0] result;

  multicycle_path_demo dut(
    .clk(clk),
    .rst(rst),
    .start(start),
    .a(a),
    .b(b),
    .done(done),
    .result(result)
  );

  always #5 clk = ~clk;

  initial begin
    clk = 0;
    rst = 1;
    start = 0;
    a = 0;
    b = 0;

    #20;
    rst = 0;

    @(posedge clk);
    a = 8'd12;
    b = 8'd5;
    start = 1;

    @(posedge clk);
    start = 0;

    repeat(5) @(posedge clk);

    $finish;
  end

  initial begin
    $monitor("T = %0t start = %b done = %b result = %d", $time,start,done,result);
  end

endmodule
