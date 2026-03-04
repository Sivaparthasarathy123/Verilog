// SR Flip Flop
module sr_ff (
    input clk,
    input s,
    input r,
    output reg  q
);
    always @(posedge clk) begin
        case ({s,r})
            2'b00: q <= q;
            2'b01: q <= 0;
            2'b10: q <= 1;
            2'b11: q <= 1'bx;  // Invalid
        endcase
    end
endmodule

// Testbench
module sr_ff_tb;
  reg clk;
  reg s;
  reg r;
  wire q;
  
  sr_ff dut (
      .clk(clk),
      .s(s),
      .r(r),
      .q(q)
  );
  
  initial clk = 0;
  always #5 clk = ~clk;
  
  initial begin
    $monitor("Time = %0t clk = %0b S = %0b R = %0b Q = %0b", $time, clk, s, r, q);
    
    s = 0; r = 0;
    #10 s = 0; r = 1;
    #10 s = 1; r = 0;
    #10 s = 1; r = 1;
    #10 $finish;
  end
endmodule
