// FSM Timeout
module timeout_fsm(
  input clk,
  input rst,
  input start,
  input response,
  output reg done,
  output reg timeout
);

  parameter IDLE    = 3'b000;
  parameter REQUEST = 3'b001;
  parameter WAIT    = 3'b010;
  parameter DONE    = 3'b011;
  parameter TOUT    = 3'b100;

  reg [2:0] state;
  reg [2:0] next_state;

  reg [6:0] timeout_counter;   

  always @(posedge clk) begin
    if(rst)
      state <= IDLE;
    else
      state <= next_state;
  end

  // Timeout Counter
  always @(posedge clk) begin
    if(rst)
      timeout_counter <= 0;

    else if(state != WAIT)
      timeout_counter <= 0;

    else
      timeout_counter <= timeout_counter + 1;
  end

  // Next State Logic
  always @(*) begin
    next_state = state;

    case(state)

      IDLE:
        begin
          if(start)
            next_state = REQUEST;
        end

      REQUEST:
        begin
          next_state = WAIT;
        end

      WAIT:
        begin
          if(response)
            next_state = DONE;

          else if(timeout_counter >= 100)
            next_state = TOUT;
        end

      DONE:
        next_state = IDLE;

      TOUT:
        next_state = IDLE;

      default:
        next_state = IDLE;

    endcase
  end

  always @(*) begin
    done    = 0;
    timeout = 0;

    case(state)

      DONE:
        done = 1;

      TOUT:
        timeout = 1;

    endcase
  end

endmodule

// Testbench
`timescale 1ns/1ps
module timeout_fsm_tb;

  reg clk;
  reg rst;
  reg start;
  reg response;

  wire done;
  wire timeout;

  timeout_fsm dut(clk, rst, response, done, timeout);

  always #5 clk = ~clk;

  initial begin

    clk      = 0;
    rst      = 1;
    start    = 0;
    response = 0;

    // Reset
    #20;
    rst = 0;

    // Response arrives before timeout
    $display("Response arrives");

    @(posedge clk);
    start = 1;

    @(posedge clk);
    start = 0;

    repeat(30)
      @(posedge clk);

    response = 1;

    @(posedge clk);
    response = 0;

    repeat(10)
      @(posedge clk);

    // Timeout occurs
    $display("Timeout");

    @(posedge clk);
    start = 1;

    @(posedge clk);
    start = 0;

    // wait more than 100 cycles
    repeat(110)
      @(posedge clk);
    #20;
    $finish;

  end

  initial begin
    $monitor("Time = %0t | State_Counter = %0d | Start = %b | Resp = %b Done = %b | Timeout = %b", $time, dut.timeout_counter, start, response, done, timeout);
    $dumpfile("fsm_timeout.vcd");
    $dumpvars;
  end

endmodule
