// T Flip Flop
module t_ff (
    input clk,
    input t,
    output reg  q
);
   
    always @(posedge clk) begin
        if (t)
            q <= ~q;
        else
            q <= 0;
    end
endmodule

// Testbench
module t_ff_tb;
  reg clk, t;
  wire q;
  
  t_ff dut (
    .clk(clk),
    .t(t),
    .q(q)
  );
  
  initial clk = 0;
  always #5 clk = ~clk;
  
  initial begin
    $monitor("Time = %0t clk = %0b T = %0b Q = %0b",$time,clk,t,q);
    
    t = 0;
    #10 t = 1;
    #10 t = 1;
    #10 $finish;
  end
  
endmodule
