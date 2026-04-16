// Sequence Detector "1110"
module seq_1110 (
  input clk,
  input rst,
  input din,
  output reg  y
);

  reg [1:0] state;
  localparam S0 = 2'd0,
             S1 = 2'd1,
             S2 = 2'd2,
             S3 = 2'd3;

  always @(posedge clk) begin
    if (rst) begin
      state <= S0;
      y <= 0;
    end 
    else begin
      y <= 0;
      case (state)
        S0: state <= din ? S1 : S0;
        S1: state <= din ? S2 : S0;
        S2: state <= din ? S3 : S0;
        S3: begin
          if (!din) begin
            state <= S0;
            y <= 1;
          end 
          else begin
            state <= S3;
          end
        end
        default: state <= S0;
      endcase
    end
  end

endmodule

// Testbench
module seq_1110_tb;

  reg clk, rst, din;
  wire y;

  seq_1110 dut (clk, rst, din, y);

  always #5 clk = ~clk;

  task send_bit(input reg b);
    begin
      din = b; 
      #10;
    end
  endtask

  initial begin
    $dumpfile("seq_1110.vcd");
    $dumpvars;

    clk = 0; rst = 1; din = 0;
    #12 rst = 0;

    send_bit(1); send_bit(1); send_bit(1); send_bit(0); // detect
    send_bit(1); send_bit(1); send_bit(1); send_bit(1); send_bit(0); // detect

    #20 $finish;
  end

endmodule
