// Non-overlapping seq detector
module nonoverlap_1011 (
  input clk,
  input rst,
  input din,
  output reg  y
);

  parameter S0 = 3'd0,
            S1 = 3'd1, // 1
            S2 = 3'd2, // 10
            S3 = 3'd3, // 101
            S4 = 3'd4; // detected

  reg [2:0] state, next_state;

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
          next_state = S4;
          y = 1;
        end 
        else
          next_state = S2;
      end
      S4: next_state = S0; // non overlap reset
      default: next_state = S0;
    endcase
  end

endmodule

// Testbench
module nonoverlap_1011_tb;

  reg clk, rst, din;
  wire y;

  nonoverlap_1011 dut (clk, rst, din, y);

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

    // 1011 => detect once
    send_bit(1); send_bit(0); send_bit(1); send_bit(1);

    // 1011011 => because non overlap, detect only on separated restart
    send_bit(0); send_bit(1); send_bit(0); send_bit(1); send_bit(1);

    #20 $finish;
  end

  initial begin
    $monitor("T = %0t din = %b y = %b", $time, din, y);
    $dumpfile("fsm_1011.vcd");
    $dumpvars;
  end

endmodule
