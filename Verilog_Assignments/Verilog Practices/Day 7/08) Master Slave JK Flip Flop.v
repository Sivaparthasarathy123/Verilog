// Master Slave JK Flip Flop
module master_slave_jk (
    input clk,
    input j,
    input k,
    output reg  q
);

    reg q_master;

    // Master latch (posedge)
    always @(posedge clk) begin
        case ({j,k})
            2'b00: q_master <= q_master;
            2'b01: q_master <= 0;
            2'b10: q_master <= 1;
            2'b11: q_master <= ~q_master;
        endcase
    end

    // Slave latch (negedge)
    always @(negedge clk) begin
        q <= q_master;
    end
endmodule

// Testbench
module master_slave_jk_tb;

    reg clk;
    reg j;
    reg k;
    wire q;

    master_slave_jk dut (
        .clk(clk),
        .j(j),
        .k(k),
        .q(q)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
      $monitor("Time = %0t clk = %0b j = %0b k = %0b q = %0b", $time, clk, j, k, q);

        // Initialize
        j = 0; k = 0;

        // HOLD
        #10 j = 0; k = 0;

        // RESET
        #10 j = 0; k = 1;

        // SET
        #10 j = 1; k = 0;

        // TOGGLE
        #10 j = 1; k = 1;

        // TOGGLE again
        #10 j = 1; k = 1;

        // HOLD again
        #10 j = 0; k = 0;

        #20 $finish;
    end

endmodule
