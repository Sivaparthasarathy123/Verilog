// 2:4 Decoder
module decoder2x4(
    input  [1:0] A,
    output reg [3:0] Y
);

always @(*) begin
    case(A)
        2'b00: Y = 4'b0001;
        2'b01: Y = 4'b0010;
        2'b10: Y = 4'b0100;
        2'b11: Y = 4'b1000;
      default: Y = 4'b0000;
    endcase
end

endmodule

module decoder2x4_tb;
  reg [1:0]A;
  wire [3:0]Y;
  
  decoder2x4 dut(A, Y);
  
  integer i;
  initial begin
    $display("---------- Decoder 2x4 ----------");
    $monitor("Time = %0t | A = %b | Y = %b", $time, A, Y);
    
    for (i = 0; i < 5; i++) begin
      A = i;
      #10;
    end
    
    $finish;
  end
endmodule
    
    
    
