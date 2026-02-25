// 8-bit Signed Booth Multiplier
module booth_multiplier_8bit(
  input  signed [7:0] A,
  input  signed [7:0] B,
  output reg signed [15:0] P
);

  integer i;
  reg signed [15:0] temp;
  reg prev;

  always @(*) begin
    temp = 0;
    prev = 0;
        
    for(i=0; i<8; i=i+1) begin
      case({B[i], prev})
        2'b01: temp = temp + ({{8{A[7]}},A} <<< i); 
        2'b10: temp = temp - ({{8{A[7]}},A} <<< i);
      endcase
        prev = B[i];
    end
        P = temp;
    end

endmodule

module booth_multiplier_8bit_tb;

  reg signed [7:0] A,B;
  wire signed [15:0] P;

  booth_multiplier_8bit dut(A,B,P);

  initial begin
    $monitor("A = %0d B = %0d -> P = %0d", A,B,P);
        
    // Positive × Positive
    A = 8'd15;  B = 8'd15;  #10;

    // Positive × Negative
    A = 8'd7;   B = -8'd12; #10;

    // Negative × Negative
    A = -8'd20; B = -8'd10; #10;

    // Large positive × large positive
    A = 8'd127; B = 8'd127; #10;

    // Large negative × positive
    A = -8'd128; B = 8'd2;  #10;

    $finish;
  end

endmodule
