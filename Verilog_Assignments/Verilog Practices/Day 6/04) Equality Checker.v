// Equality checker for 16-bit
module equality_checker(
    input  [15:0] A,
    input  [15:0] B,
    output EQ
);
    assign EQ = (A == B);
endmodule

// Testbench
module equality_checker_tb;
  reg [15:0] A, B;
  wire EQ;

  equality_checker uut (
      .A(A),
      .B(B),
      .EQ(EQ)
  );

  initial begin
    $monitor("Time = %0t | A = %0d | B = %0d | EQ = %0d", $time, A, B, EQ);
      A = 16'd10; B = 16'd5;  #10;
      A = 16'd7;  B = 16'd7;  #10;
      A = 16'd2;  B = 16'd8;  #10;
      $finish;
  end
endmodule
