// FSM with timeout
module fsm_timeout (
  input clk,
  input rst,
  input start,
  input ack,
  output reg  busy,
  output reg  done,
  output reg  timeout
);

  parameter IDLE     = 2'd0,
            WAIT_ACK = 2'd1,
            DONE     = 2'd2;

  parameter TIMEOUT_LIMIT = 4;

  reg [1:0] state;
  reg [2:0] count;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      state   <= IDLE;
      count   <= 0;
      busy    <= 0;
      done    <= 0;
      timeout <= 0;
    end
    else begin
      done    <= 0;
      timeout <= 0;

      case (state)
        IDLE: begin
          busy  <= 0;
          count <= 0;
          if (start) begin
            state <= WAIT_ACK;
            busy  <= 1;
          end
        end

        WAIT_ACK: begin
          busy <= 1;
          if (ack) begin
            state <= DONE;
            busy  <= 0;
          end
          else if (count == TIMEOUT_LIMIT-1) begin
            state   <= IDLE;
            busy    <= 0;
            timeout <= 1;
            count   <= 0;
          end 
          else begin
            count <= count + 1;
          end
        end

        DONE: begin
          done  <= 1;
          busy  <= 0;
          count <= 0;
          state <= IDLE;
        end

        default: begin
          state   <= IDLE;
          busy    <= 0;
          done    <= 0;
          timeout <= 0;
          count   <= 0;
        end
      endcase
    end
  end

endmodule

// Testbench
module fsm_timeout_tb;

  reg clk, rst, start, ack;
  wire busy, done, timeout;

  fsm_timeout dut (
    .clk(clk),
    .rst(rst),
    .start(start),
    .ack(ack),
    .busy(busy),
    .done(done),
    .timeout(timeout)
  );

  always #5 clk = ~clk;

  initial begin
    clk = 0; rst = 1; start = 0; ack = 0;
    #12 rst = 0;

    // successful transaction
    #10 start = 1;
    #10 start = 0;
    #20 ack = 1;
    #10 ack = 0;

    // timeout transaction
    #20 start = 1;
    #10 start = 0;
    // no ack given

    #80 $finish;
  end

  initial begin
    $monitor("T = %0t start = %b ack = %b busy = %b done = %b timeout = %b",
             $time, start, ack, busy, done, timeout);
    $dumpfile("fsm_with_timeout.vcd");
    $dumpvars;
  end

endmodule
