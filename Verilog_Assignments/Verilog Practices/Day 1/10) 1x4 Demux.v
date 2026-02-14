// 1:4 Demux
module demux1x4(
  input I, S0, S1,
  output reg Y0, Y1, Y2, Y3
);
  
  always@(*)begin
    Y0 = 0;
    Y1 = 0;
    Y2 = 0;
    Y3 = 0;
    
    case({S0, S1})
      2'b00: Y0 = I;
      2'b01: Y1 = I;
      2'b10: Y2 = I;
      2'b11: Y3 = I;
    endcase
  end
  
endmodule

module demux1x4_tb;
  reg I, S0,S1;
  wire Y0, Y1, Y2, Y3;
  
  demux1x4 dut (I, S0, S1, Y0, Y1, Y2, Y3);
  
  integer i;
  initial begin
    $display("--------- 1x4 Demux ----------");
    $monitor(" I = %b | S0 = %b | S1 = %b | Y0 = %b | Y1 = %b | Y2 = %b | Y3 = %b", I, S0, S1, Y0, Y1, Y2, Y3);
    
    for(i = 0; i <= 16 ; i++)begin
      {I, S0, S1} = $urandom;
      #10;
    end
    $finish;
  end
endmodule
    
