// Sequence Detector "101" (Moore) 
module seq_101_moore (
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
    if (rst)
      state <= S0;
    else begin
      case (state)
        S0: state <= din ? S1 : S0;
        S1: state <= din ? S1 : S2;
        S2: state <= din ? S3 : S0;
        S3: state <= din ? S1 : S2;
        default: state <= S0;
      endcase
    end
  end

  always @(*) begin
    y = (state == S3);
  end

endmodule

// Testbench
module seq_101_moore_tb;

  reg clk, rst, din;
  wire y;

  seq_101_moore dut (clk, rst, din, y);

  always #5 clk = ~clk;

  task send_bit(input reg b);
    begin
      din = b;
      #10;
    end
  endtask

  initial begin
    $dumpfile("tb_seq_101_moore.vcd");
    $dumpvars;

    clk = 0;
    rst = 1; 
    din = 0;
    #12 rst = 0;

    send_bit(1);
    send_bit(0);
    send_bit(1); 

    send_bit(1);
    send_bit(0);
    send_bit(1);

    #20;
    $finish;
  end

endmodule
