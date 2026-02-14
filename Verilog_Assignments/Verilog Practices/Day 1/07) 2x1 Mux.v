// 2:1 MUX using gates
module mux2to1(
    input I0,
    input I1,
    input S,
    output reg Y
);
    
  wire S_bar, w0, w1;

  // NOT gate
  not (S_bar, S);

  // AND gates
  and (w0, I0, S_bar);
  and (w1, I1, S);

  // OR gate
  or  (Y, w0, w1);
  
//   always @(*) begin
//     Y = (~S & I0) | (S & I1);
//   end

endmodule

module mux2to1_tb;

  reg I0, I1, S;
  wire Y;

  mux2to1 dut(I0, I1, S, Y);
  
  integer i;
  initial begin
    $display("-------- 2x1 Mux using Gates---------");
    $monitor("S = %b | I0 = %b | I1 = %b | Y = %b", S, I0, I1, Y);
    
    for(i = 0; i < 8; i++) begin
       {S, I0, I1} = $urandom;  
       #10;
    end
     $finish;
    end

endmodule
