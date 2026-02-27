// Less than Detector
module less_than_detector(
    input  [15:0] A,
    input  [15:0] B,
    output LT
);
    assign LT = (A < B);
endmodule

// Testbench
module less_than_detector_tb;
  reg [15:0] A, B;
  wire LT;

  less_than_detector uut (
    .A(A),
    .B(B),
    .LT(LT)
  );

  initial begin
    $monitor("Time = %0t | A = %0d | B = %0d | LT = %0d", $time, A, B, LT);
      A = 16'd10; B = 16'd5;  #10;
      A = 16'd7;  B = 16'd7;  #10;
      A = 16'd2;  B = 16'd8;  #10;
      $finish;
  end
endmodule


