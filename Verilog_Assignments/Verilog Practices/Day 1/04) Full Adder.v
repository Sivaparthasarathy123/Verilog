// Full Adder
module full_adder(
  input a,
  input b,
  input c,
  output reg sum,
  output reg carry
);
  
  always@(*)begin
    sum   = a ^ b ^ c;
    carry = (a & b)|(b & c)|(a & c);
  end
endmodule

module full_adder_tb;
  reg a, b, c;
  wire sum, carry;
  
  full_adder dut (a, b, c, sum, carry);
  
  integer i;
  initial begin
    $monitor(" A = %b | B = %b | C = %b | SUM = %b | CARRY = %b ", a, b, c, sum, carry);
    
    for(i = 0; i < 8; i++) begin
      {a, b, c} = $urandom;  
      #10;
    end

     $finish;
    end

endmodule
