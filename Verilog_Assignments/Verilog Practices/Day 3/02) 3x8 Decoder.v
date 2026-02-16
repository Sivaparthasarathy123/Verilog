// Decoder 3 : 8
module decoder3x8(
  input [2:0] I,
  output reg [7:0] Y
);
  
  always@(*)begin
    Y = 8'b00000000;
    Y[I] = 1'b1;
  end
endmodule

module decoder3x8_tb;
  reg [2:0] I;
  wire [7:0] Y;
  
  decoder3x8 dut(I, Y);
  
  integer i;
  initial begin
    $display("---------- Decoder 3x8 ----------");
    $monitor("Time = %0t | I = %b | Y = %b", $time, I, Y);
    
    for (i = 0; i < 8; i++) begin
      I = i;
      #10;
    end
    
    $finish;
  end
endmodule
