// D Latch
module d_latch (
    input  wire d,
    input  wire en,
    output reg  q
);
    always @(*) begin
        if (en)
            q = d;
    end
endmodule

// Testbench
module d_latch_tb;

    reg d, en;
    wire q;

    d_latch dut (.d(d), .en(en), .q(q));

    initial begin
      $monitor("Time = %0t en = %b d = %b q = %b", $time, en, d, q);

        en=0; d=0;
        #10 en=1; d=1;
        #10 d=0;
        #10 en=0; d=1;   
        #10 $finish;
    end
endmodule
  
