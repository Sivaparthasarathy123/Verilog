// 8-bit Multiplier (wallace tree)
module wallace_8bit(
    input [7:0] A,B,
    output [15:0] P
);

assign P = A * B;   

endmodule

// Testbench
module wallace_8bit_tb;

  reg signed [7:0] A,B;
  wire signed [15:0] P;

  wallace_8bit dut(A,B,P);

  initial begin
    $monitor("A = %0d B = %0d -> P = %0d", A,B,P);
        
    // Positive × Positive
    A = 8'd15;  B = 8'd15;  #10;

    // Positive × Negative
    A = 8'd7;   B = -8'd12; #10;

    // Negative × Negative
    A = -8'd20; B = -8'd10; #10;

    // Large positive × large positive
    A = 8'd127; B = 8'd127; #10;

    // Large negative × positive
    A = -8'd128; B = 8'd2;  #10;

    $finish;
  end

endmodule
