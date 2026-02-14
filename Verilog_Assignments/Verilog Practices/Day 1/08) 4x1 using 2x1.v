// 4:1 MUX using 2:1 MUXes
module mux2to1(
    input I0,
    input I1,
    input S,
    output reg Y
);
  
    always @(*) begin
      Y = (~S & I0) | (S & I1);
    end

endmodule

module mux4to1(
  input I0, I1, I2, I3,
  input S0, S1,
  output reg Y
);
  
  // First stage
  mux2to1 MUX_A(I0, I1, S0, w0);
  mux2to1 MUX_B(I2, I3, S0, w1);

  // Second stage
  mux2to1 MUX_C(w0, w1, S1, Y);
  
endmodule

module mux4to1_tb;

  reg I0, I1, I2, I3, S0, S1;
  wire Y;

  mux4to1 dut(I0, I1, I2, I3, S0, S1, Y);
  
  integer i;
  initial begin
    $display("-------- 4x1 Mux using 2x1 Gates---------");
    $monitor("S0 = %b | S1 = %b | I0 = %b | I1 = %b | I2 = %b | I3 = %b | Y = %b", S0, S1, I0, I1, I2, I3, Y);
    
    for(i = 0; i <= 16; i++) begin
      {S0, S1, I0, I1, I2, I3} = $urandom;  
       #10;
    end
     $finish;
    end

endmodule
