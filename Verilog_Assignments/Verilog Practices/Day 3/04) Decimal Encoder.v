// Decimal to BCD encoder
module decimal_to_bcd(
  input  [9:0] D,  
  output reg [3:0] B
);
 
  always @(*) begin
    casex (D)
        10'bxxxxxxxxx1: B = 4'd0;  
        10'bxxxxxxxx10: B = 4'd1;
        10'bxxxxxxx100: B = 4'd2;
        10'bxxxxxx1000: B = 4'd3;
        10'bxxxxx10000: B = 4'd4;
        10'bxxxx100000: B = 4'd5;
        10'bxxx1000000: B = 4'd6;
        10'bxx10000000: B = 4'd7;
        10'bx100000000: B = 4'd8;
        10'b1000000000: B = 4'd9;  
        default: B = 4'd0;
    endcase
  end

endmodule

// Testbench
module decimal_to_bcd_tb;
  reg [9:0] D;
  wire [3:0] B;

  decimal_to_bcd dut(D, B);

    integer i;
    initial begin
      $display("----------- Decimal to BCD -----------");
      $monitor("Time = %0t | D = %0d | B = %d", $time, D, B);

       for (i = 0; i < 10; i++) begin
            D = i;
            #10;
       end
        #5;
        $finish;
    end
endmodule


