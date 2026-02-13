// Half Adder
module half_adder(
  input a,
  input b,
  output reg sum,
  output reg carry
);
  
  always@(*)begin
    sum   = a ^ b;
    carry = a & b;
  end
endmodule

module half_adder_tb;
  reg a, b;
  wire sum, carry;
  
  half_adder dut (a, b, sum, carry);
  
  initial begin
    $display(" A B SUM CARRY");
    $monitor(" %b %b %b %b ", a, b, sum, carry);
    
     a = 0; b = 0; #10; 
     a = 0; b = 1; #10;
     a = 1; b = 0; #10;
     a = 1; b = 1; #10; 

     $finish;
    end

endmodule
