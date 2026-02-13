// Half Subtractor
module half_subtractor(
  input a,
  input b,
  output reg diff,
  output reg borrow
);
  
  always@(*)begin
    diff   =  a ^ b;
    borrow = ~a & b;
  end
endmodule

module half_subtractor_tb;
  reg a, b;
  wire diff, borrow;
  
  half_subtractor dut (a, b, diff, borrow);
  
  initial begin
    $display(" A B DIFF BORROW");
    $monitor(" %b %b %b %b ", a, b, diff, borrow);
    
     a = 0; b = 0; #10; 
     a = 0; b = 1; #10;
     a = 1; b = 0; #10;
     a = 1; b = 1; #10; 

     $finish;
    end

endmodule
