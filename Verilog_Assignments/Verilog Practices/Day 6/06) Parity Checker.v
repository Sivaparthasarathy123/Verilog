// Parity checker (even/odd)
module parity_checker(
  input  [15:0] A,
  output even_parity,
  output odd_parity
);
  assign even_parity = ~(^A); // if number of 1's is even means output is 1
  assign odd_parity  = ^A;    // if number of 1's is odd means output is 1
endmodule

// Testbench
module parity_checker_tb;
  reg [15:0] A;
  wire even_parity, odd_parity;

  parity_checker uut (
      .A(A),
      .even_parity(even_parity),
      .odd_parity(odd_parity)
  );

    initial begin
      $monitor("A = %0d | Even = %0d | Odd = %0d", A, even_parity, odd_parity);
        A = 16'b0000000000000000; #10;
        A = 16'b0000000000000001; #10;
        A = 16'b1010101010101010; #10;
        A = 16'b1111111111111111; #10;
        $finish;
    end
endmodule
