// Full Subtractor
module full_subtractor(
  input a,
  input b,
  input c,
  output reg diff,
  output reg borrow
);
  
  always@(*)begin
    diff   = a ^ b ^ c;
    borrow = (~a & b)|((~a | b) & c);   
  end
endmodule

module full_subtractor_tb;
  reg a, b, c;
  wire diff, borrow;
  
  full_subtractor dut (a, b, c, diff, borrow);
  
  integer i;
  initial begin
    $monitor(" A = %b | B = %b | C = %b | DIFFERENCE = %b | BORROW = %b ", a, b, c, diff, borrow);
    
    for(i = 0; i < 8; i++) begin
      {a, b, c} = $urandom;  
      #10;
    end

     $finish;
    end

endmodule
