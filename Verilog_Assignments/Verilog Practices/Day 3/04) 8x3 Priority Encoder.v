// 8:3 Priority Encoder
module priority_encoder_8x3(
  input  [7:0] A,      
  output reg [2:0] Y   
);
    always @(*) begin
        casez(A)
            8'b1zzzzzzz: Y = 3'd7;  
            8'b01zzzzzz: Y = 3'd6;  
            8'b001zzzzz: Y = 3'd5; 
            8'b0001zzzz: Y = 3'd4;
            8'b00001zzz: Y = 3'd3;
            8'b000001zz: Y = 3'd2;
            8'b0000001z: Y = 3'd1;
            8'b0000000z: Y = 3'd0;
            default: Y = 3'd0; 
        endcase
    end
endmodule


module priority_encoder_tb;
  reg [7:0] A;
  wire [2:0] Y;

    priority_encoder_8x3 dut(A, Y);

    integer i;
    initial begin
      $display("----------- priority Encoder 8x3-----------");
      $monitor("Time = %0t | A = %b | Y = %b", $time, A, Y);

       for (i = 0; i < 16; i++) begin
            A = i;
            #10;
        end

        $finish;
    end
endmodule
