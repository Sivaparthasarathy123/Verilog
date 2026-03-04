// JK Flip Flop
module jk_ff (
    input clk,
    input j,
    input k,
    output reg  q
);
    always @(posedge clk) begin
        case ({j,k})
            2'b00: q <= q;      // Hold
            2'b01: q <= 0;      // Reset
            2'b10: q <= 1;      // Set
            2'b11: q <= ~q;     // Toggle
        endcase
    end
endmodule

// Testbench
module jk_ff_tb;
  reg clk;
  reg j;
  reg k;
  wire q;
  
  jk_ff dut (
      .clk(clk),
      .j(j),
      .k(k),
      .q(q)
  );
  
  initial clk = 0;
  always #5 clk = ~clk;
  initial begin
    $monitor("Time = %0t clk = %0b j = %0b k = %0b q = %0b", $time, clk, j, k, q);
    
    j = 0; k = 0;
    #10 j = 0; k = 1;
    #10 j = 1; k = 0;
    #10 j = 1; k = 1;
    #10 $finish;
  end
endmodule
