// Moore FSM for pattern "1101"
module moore_1101 (
  input clk,
  input rst,
  input din,
  output reg  y
);

  parameter S0 = 3'd0,
            S1 = 3'd1, // 1
            S2 = 3'd2, // 11
            S3 = 3'd3, // 110
            S4 = 3'd4; // 1101 detected

  reg [2:0] state, next_state;

  always @(posedge clk) begin
    if (rst)
      state <= S0;
    else
      state <= next_state;
  end

  always @(*) begin
    case (state)
      S0: next_state = din ? S1 : S0;
      S1: next_state = din ? S2 : S0;
      S2: next_state = din ? S2 : S3;
      S3: next_state = din ? S4 : S0;
      S4: next_state = din ? S2 : S0;
      default: next_state = S0;
    endcase
  end

  always @(*) begin
    y = (state == S4);
  end

endmodule

// Testbench
module moore_1101_tb;

  reg clk, rst, din;
  wire y;

  moore_1101 dut (clk, rst, din, y);

  always #5 clk = ~clk;

  task send_bit(input reg b);
    begin
      din = b; #10;
    end
  endtask

  initial begin
    clk = 0; rst = 1; din = 0;
    #12 rst = 0;

    // sequence 1101
    send_bit(1); send_bit(1); send_bit(0); send_bit(1);

    // next sample
    send_bit(1); send_bit(1); send_bit(0); send_bit(0);
    send_bit(1); send_bit(1); send_bit(0); send_bit(1);

    #20 $finish;
  end

  initial begin
    $monitor("T = %0t din = %b y = %b", $time, din, y);
    $dumpfile("fsm_1101.vcd");
    $dumpvars;
  end

endmodule
