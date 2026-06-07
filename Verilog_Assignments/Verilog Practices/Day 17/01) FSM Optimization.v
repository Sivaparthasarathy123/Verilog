// FSM Optimization
module reachability_fsm (
  input clk,
  input rst,
  input in,
  output reg [2:0]state
);

  localparam S0 = 3'd0;
  localparam S1 = 3'd1;
  localparam S2 = 3'd2;
  localparam S3 = 3'd3;
  localparam S4 = 3'd4; // unreachable

  reg [2:0] next_state;

  always @(posedge clk) begin
    if(rst)
      state <= S0;
    else
      state <= next_state;
  end

  always @(*) begin
    case(state)

      S0:
        if(in)
          next_state = S1;
      else
        next_state = S0;

      S1:
        next_state = S2;

      S2:
        next_state = S3;

      S3:
        next_state = S0;

      // No path enters S4

      S4:
        next_state = S4;

      default:
        next_state = S0;

    endcase
  end

endmodule

// Testbench
`timescale 1ns/1ps
module reachability_fsm_tb;

  reg clk;
  reg rst;
  reg in;
  wire [2:0] state;

  reachability_fsm dut (clk, rst, in, state);

  always #5 clk = ~clk;

  reg [7:0] visited;

  always @(posedge clk) begin
    visited[state] <= 1'b1;
  end

  initial begin

    clk = 0;
    rst = 1;
    in  = 0;
    visited = 0;

    #20;
    rst = 0;

    repeat(5)begin
      @(posedge clk);
      in = 1;

      @(posedge clk);
      in = 0;
    end

    #20;
    if(visited[0])
      $display("S0 reached");

    if(visited[1])
      $display("S1 reached");

    if(visited[2])
      $display("S2 reached");

    if(visited[3])
      $display("S3 reached");

    if(visited[4])
      $display("S4 reached");
    else
      $display("S4 NOT reached (UNREACHABLE)");
    $finish;

  end

  initial begin
    $monitor("Time = %0t State = %0d In = %b",$time,state,in);
  end

endmodule
