// Mealy FSM for pattern "1001"
module mealy_1001 (
  input clk,
  input rst,
  input din,
  output reg  y
);

  parameter S0 = 2'd0,
            S1 = 2'd1, // 1
            S2 = 2'd2, // 10
            S3 = 2'd3; // 100

  reg [1:0] state, next_state;

  always @(posedge clk) begin
    if (rst)
      state <= S0;
    else
      state <= next_state;
  end

  always @(*) begin
    y = 1'b0;
    case (state)
      S0: next_state = din ? S1 : S0;
      S1: next_state = din ? S1 : S2;
      S2: next_state = din ? S1 : S3;
      S3: begin
        if (din) begin
          next_state = S1;
          y = 1'b1;
        end
        else begin
          next_state = S0;
        end
      end
      default: next_state = S0;
    endcase
  end

endmodule

// Testbench
module mealy_1001_tb;

  reg clk, rst, din;
  wire y;

  mealy_1001 dut (clk, rst, din, y);

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

    send_bit(1); send_bit(0); send_bit(0); send_bit(1); // detect
    send_bit(1); send_bit(0); send_bit(1); send_bit(0); // no detect
    send_bit(1); send_bit(0); send_bit(0); send_bit(1); // detect

    #20 $finish;
  end

  initial begin
    $monitor("T = %0t din = %b y = %b", $time, din, y);
    $dumpfile("fsm_1001.vcd");
    $dumpvars;
  end

endmodule
