// FSM Coding Styles - One-hot vs Binary vs Gray code
module fsm_binary (
  input clk,
  input rst,
  input next,
  output reg [1:0] state
);

  localparam IDLE = 2'b00;
  localparam S1   = 2'b01;
  localparam S2   = 2'b10;
  localparam S3   = 2'b11;

  always @(posedge clk) begin
    if (rst)
      state <= IDLE;
    else if (next) begin
      case (state)
        IDLE: state <= S1;
        S1  : state <= S2;
        S2  : state <= S3;
        S3  : state <= IDLE;
        default: state <= IDLE;
      endcase
    end
  end

endmodule

module fsm_onehot (
  input clk,
  input rst,
  input next,
  output reg [3:0] state
);

  localparam IDLE = 4'b0001;
  localparam S1   = 4'b0010;
  localparam S2   = 4'b0100;
  localparam S3   = 4'b1000;

  always @(posedge clk) begin
    if (rst)
      state <= IDLE;
    else if (next) begin
      case (state)
        IDLE: state <= S1;
        S1  : state <= S2;
        S2  : state <= S3;
        S3  : state <= IDLE;
        default: state <= IDLE;
      endcase
    end
  end

endmodule

module fsm_gray (
  input clk,
  input rst,
  input next,
  output reg [1:0] state
);

  localparam IDLE = 2'b00;
  localparam S1   = 2'b01;
  localparam S2   = 2'b11;
  localparam S3   = 2'b10;

  always @(posedge clk) begin
    if (rst)
      state <= IDLE;
    else if (next) begin
      case (state)
        IDLE: state <= S1;
        S1  : state <= S2;
        S2  : state <= S3;
        S3  : state <= IDLE;
        default: state <= IDLE;
      endcase
    end
  end

endmodule

// Testbench
module fsm_encoding;

  reg clk;
  reg rst;
  reg next;

  wire [1:0] state_binary;
  wire [3:0] state_onehot;
  wire [1:0] state_gray;

  integer i;

  fsm_binary u_binary (
    .clk(clk),
    .rst(rst),
    .next(next),
    .state(state_binary)
  );

  fsm_onehot u_onehot (
    .clk(clk),
    .rst(rst),
    .next(next),
    .state(state_onehot)
  );

  fsm_gray u_gray (
    .clk(clk),
    .rst(rst),
    .next(next),
    .state(state_gray)
  );

  always #5 clk = ~clk;

  initial begin
    $dumpfile("fsm_encoding.vcd");
    $dumpvars;

    clk  = 0;
    rst  = 1;
    next = 0;

    #12;
    rst = 0;

    for (i = 0; i < 8; i = i + 1) begin
      @(negedge clk);
      next = 1'b1;

      @(negedge clk);
      next = 1'b0;
    end

    #20;
    $finish;
  end

  always @(posedge clk) begin
    #1;
    $display("Time = %0t | next = %b | binary = %b | one-hot = %b | gray = %b",$time, next, state_binary, state_onehot, state_gray);
  end

endmodule
