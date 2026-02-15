// 16:1 MUX using 4:1 MUXes
module mux4x1(
    input [3:0] I,
    input [1:0] S,  
    output reg Y
);

  always @(*) begin
    case(S)
        2'b00: Y = I[0];
        2'b01: Y = I[1];
        2'b10: Y = I[2];
        2'b11: Y = I[3];
        default: Y = 1'bx;
    endcase
  end

endmodule


module mux16x1(
  input [15:0] I,    
  input [3:0] S,     
  output Y
);

  wire w0, w1, w2, w3;  

  // combination of 4 - 4x1 muxes
  mux4x1 M0(I[3:0],   S[1:0], w0);
  mux4x1 M1(I[7:4],   S[1:0], w1);
  mux4x1 M2(I[11:8],  S[1:0], w2);
  mux4x1 M3(I[15:12], S[1:0], w3);

  // 4x1 mux 
  mux4x1 M_final({w0, w1, w2, w3}, S[3:2], Y);

endmodule

// Testbench
module mux16x1_tb;

  reg [15:0] I;
  reg [3:0] S;
  wire Y;

  mux16x1 dut(I, S, Y);

  integer i;
  initial begin
    $display("----------- 16x1 mux using 4x1 muxes -----------");
    $monitor("I = %b | S3 = %b | S2 = %b | S1 = %b | S0 = %b | Y = %b", I, S[3], S[2], S[1], S[0], Y);

    for(i = 0; i < 16; i = i + 1) begin
        S = $urandom;
        I = $urandom;
        #10;
    end
    $finish;
  end

endmodule
