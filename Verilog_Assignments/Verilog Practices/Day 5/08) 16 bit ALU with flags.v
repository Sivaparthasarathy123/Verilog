// 16 bit ALU with flags
module alu_16bit_flags(
  input [15:0] A,B,
  input [1:0] sel,
  output reg [15:0] Y,
  output reg Z,C,V,N
);

  reg [16:0] temp;

  always @(*) begin
    case(sel)
        2'b00: temp = A + B;
        2'b01: temp = A - B;
        default: temp = 0;
    endcase
    
    Y = temp[15:0];
    C = temp[16];  // Carry Flag
    Z = (Y==0);    // zero flag
    N = Y[15];     // Empty flag
    V = (A[15]==B[15]) && (Y[15]!=A[15]);  // Overflow Flag
  end

endmodule
// Testbench
module alu_16bit_flags_tb;

  reg  [15:0] A,B;
  reg  [1:0] sel;
  wire [15:0] Y;
  wire Z,C,V,N;

  alu_16bit_flags dut (A,B,sel,Y,Z,C,V,N);

  initial begin
    $monitor("Tiem = %0t A = %0d B = %0d SEL = %0b Y = %0d Z = %0b C = %0b V =%0b N = %0b",$time,A,B,sel,Y,Z,C,V,N);

    // Addition
    A = 16'd100; B = 16'd50; sel = 2'b00; #10;

    // Subtraction
    sel = 2'b01; #10;

    // Zero flag check
    A = 16'd5; B = 16'd5; sel = 2'b01; #10;

    // Overflow case
    A = 16'h7FFF; B = 16'd1; sel = 2'b00; #10;

    $finish;
  end

endmodule
