// Floating Point Adder
module fp_adder(
  input real A,
  input real B,
  output real Y
);

  assign Y = A + B;

endmodule

// Testbench
module fp_adder_tb;

  real A,B;
  real Y;

  fp_adder dut (A,B,Y);

initial begin
  $monitor("Time = %0t A = %0f B = %0f Y = %0f", $time,A,B,Y);

    A = 10.5; B = 2.25; #10;
    A = -5.75; B = 3.5; #10;
    A = 100.125; B = 200.875; #10;

    $finish;
end

endmodule
