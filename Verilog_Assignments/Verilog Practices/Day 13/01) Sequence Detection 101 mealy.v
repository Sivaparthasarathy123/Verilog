// Sequence Detector "101" (Mealy)
module seq_101_mealy (
  input clk,
  input rst,
  input din,
  output reg  y
);

  reg [1:0] state;
  localparam S0 = 2'd0,
             S1 = 2'd1,
             S2 = 2'd2;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      state <= S0;
      y     <= 1'b0;
    end else begin
      y <= 1'b0;
      case (state)
        S0: begin
          if (din) state <= S1;
          else     state <= S0;
        end

        S1: begin
          if (din) state <= S1;
          else     state <= S2;
        end

        S2: begin
          if (din) begin
            state <= S1;
            y     <= 1'b1;
          end else begin
            state <= S0;
          end
        end

        default: state <= S0;
      endcase
    end
  end

endmodule

// Testbench
module seq_101_mealy_tb;

  reg clk, rst, din;
  wire y;

  seq_101_mealy dut (clk, rst, din, y);

  initial clk = 0;
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

    send_bit(1);
    send_bit(0);
    send_bit(1); // detect

    send_bit(1);
    send_bit(0);
    send_bit(1); // detect again

    send_bit(0);
    send_bit(0);
    send_bit(1);
    send_bit(0);
    send_bit(1); // detect

    #20;
    $finish;
  end

  initial begin
    $dumpfile("seq_101_mealy.vcd");
    $dumpvars;
  end

endmodule
