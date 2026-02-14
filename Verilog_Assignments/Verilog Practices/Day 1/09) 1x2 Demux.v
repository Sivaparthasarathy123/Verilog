// 1:2 Demux
module demux1x2(
  input I, S,
  output reg Y0, Y1
);
  
  always@(*)begin
    if(S == 0)begin
      Y0 = I;
      Y1 = 0;
    end
    else begin
      Y1 = I;
      Y0 = 0;
    end
  end
  
endmodule

module demux1x2_tb;
  reg I, S;
  wire Y0, Y1;
  
  demux1x4 dut (I, S, Y0, Y1);
  
  integer i;
  initial begin
    $display("--------- 1x2 Demux ----------");
    $monitor(" I = %b | S = %b | Y0 = %b | Y1 = %b", I, S, Y0, Y1);
    
    for(i = 0; i <= 8 ; i++)begin
      {I, S} = $urandom;
      #10;
    end
    $finish;
    
  end
endmodule
    
