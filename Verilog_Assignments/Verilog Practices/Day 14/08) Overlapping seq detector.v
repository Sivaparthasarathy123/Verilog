// Overlapping seq detector
module overlap_1011 (
  input clk,
  input rst,
  input din,
  output reg  y
);

  parameter S0 = 2'd0,
            S1 = 2'd1, // 1
            S2 = 2'd2, // 10
            S3 = 2'd3; // 101

  reg [1:0] state, next_state;

  always @(posedge clk) begin
    if (rst)
      state <= S0;
    else
      state <= next_state;
  end

  always @(*) begin
    y = 0;
    case (state)
      S0: next_state = din ? S1 : S0;
      S1: next_state = din ? S1 : S2;
      S2: next_state = din ? S3 : S0;
      S3: begin
        if (din) begin
          y = 1;
          next_state = S1; // overlap allowed
        end
        else begin
          next_state = S2;
        end
      end
      default: next_state = S0;
    endcase
  end

endmodule

// Testbench
module overlap_1011_tb;

  reg clk, rst, din;
  wire y;

  overlap_1011 dut (clk, rst, din, y);

  always #5 clk = ~clk;

  task send_bit(input reg b);
    begin
      din = b;
      #10;
    end
  endtask

  initial begin
    clk = 0; rst = 1; din = 0;
    #12 rst = 0;

    // pattern stream with possible overlap behavior
    send_bit(1); send_bit(0); send_bit(1); send_bit(1); // detect
    send_bit(0); send_bit(1); send_bit(1);              // can help overlap depending on stream
    send_bit(0); send_bit(1); send_bit(1);              // detect again

    #20 $finish;
  end

  initial begin
    $monitor("T = %0t din = %b y = %b", $time, din, y);
    $dumpfile("fsm_1011.vcd");
    $dumpvars;
  end

endmodule
