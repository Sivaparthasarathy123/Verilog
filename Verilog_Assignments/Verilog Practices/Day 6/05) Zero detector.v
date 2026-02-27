// zero detector
module zero_detector(
  input  [15:0] A,
  output Z
);
  assign Z = (A == 16'd0);
endmodule

// Testbench
module zero_detector_tb;
  reg [15:0] A;
  wire Z;

  zero_detector uut (
      .A(A),
      .Z(Z)
  );

  initial begin
    $monitor("A = %0d | Z = %0d", A, Z);
      A = 16'd0;  #10;
      A = 16'd5;  #10;
      A = 16'd65535; #10;
      $finish;
  end
endmodule
