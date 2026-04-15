// Sequence Detector "1001"
module seq_1001 (
  input clk,
  input rst,
  input din,
  output reg  y
);

  reg [2:0] state;
  localparam S0 = 3'd0,
             S1 = 3'd1,
             S2 = 3'd2,
             S3 = 3'd3;

  always @(posedge clk) begin
    if (rst) begin
      state <= S0;
      y <= 0;
    end 
    else begin
      y <= 0;
      case (state)
        S0: state <= din ? S1 : S0;
        S1: state <= din ? S1 : S2;
        S2: state <= din ? S1 : S3;
        S3: begin
          if (din) begin
            state <= S1;
            y <= 1;
          end 
          else begin
            state <= S0;
          end
        end
        default: state <= S0;
      endcase
    end
  end

endmodule

// Testbench
module seq_1001_tb;

  reg clk, rst, din;
  wire y;

  seq_1001 dut (clk, rst, din, y);

  always #5 clk = ~clk;

  task send_bit(input reg b);
    begin
      din = b; #10;
    end
  endtask

  initial begin
    $dumpfile("seq_1001.vcd");
    $dumpvars;

    clk = 0; rst = 1; din = 0;
    #12 rst = 0;

    send_bit(1); send_bit(0); send_bit(0); send_bit(1); // detect
    send_bit(0); send_bit(1); send_bit(0); send_bit(0); send_bit(1); // detect

    #20 $finish;
  end

endmodule
