// Priority Encoder 4x2
module priority_encoder_4x2(
    input  [3:0] A,      
    output reg [1:0] Y   
);
    always @(*) begin
        casez(A)
            4'b1???: Y = 2'd3;  
            4'b01??: Y = 2'd2;  
            4'b001?: Y = 2'd1; 
            4'bx001: Y = 2'd0;    
            default: Y = 2'd0; 
        endcase
    end
endmodule


module priority_encoder_tb;
    reg [3:0] A;
    wire [1:0] Y;

    priority_encoder_4bit dut(A, Y);

    integer i;
    initial begin
      $display("----------- priority Encoder 4x2 -----------");
      $monitor("Time = %0t | A = %b | Y = %b", $time, A, Y);

       for (i = 0; i < 16; i++) begin
            A = i;
            #10;
        end

        $finish;
    end
endmodule
