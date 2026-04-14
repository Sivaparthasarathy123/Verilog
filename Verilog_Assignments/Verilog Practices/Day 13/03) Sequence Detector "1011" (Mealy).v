// Sequence Detector "1011" (Mealy)
module seq_1011_mealy (
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

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      state <= S0;
      y     <= 1'b0;
    end 
    else begin
      y <= 1'b0;
      case (state)
        S0: state <= din ? S1 : S0;
        S1: state <= din ? S1 : S2;
        S2: state <= din ? S3 : S0;
        S3: begin
          if (din) begin
            state <= S1;
            y     <= 1'b1;
          end
          else begin
            state <= S2;
          end
        end
        default: state <= S0;
      endcase
    end
  end

endmodule

// Testbench
module seq_1011_mealy_tb;

  reg clk, rst, din;
  wire y;

  seq_1011_mealy dut (.clk(clk), .rst(rst), .din(din), .y(y));

  always #5 clk = ~clk;

  task send_bit(input reg b);
    begin
      din = b;
      #10;
    end
  endtask

  initial begin
    $dumpfile("seq_1011_mealy.vcd");
    $dumpvars;

    clk = 0; rst = 1; din = 0;
    #12 rst = 0;

    send_bit(1);
    send_bit(0);
    send_bit(1);
    send_bit(1); // detect

    send_bit(0);
    send_bit(1);
    send_bit(1);
    send_bit(0);

    send_bit(1);
    send_bit(0);
    send_bit(1);
    send_bit(1); // detect

    #20 $finish;
  end

endmodule
