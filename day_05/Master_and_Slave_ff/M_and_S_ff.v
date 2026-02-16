module M_and_S_ff(
    input J,
    input K,
    input clk,
    output reg Q,
    output reg Qbar);

     reg master_Q;

   initial begin
     Q    = 0;
     Qbar = 1;
     master_Q=0;
   end
   
   //Master latch
   always@(posedge clk)begin
     case({J,K})
        2'b00: master_Q <= master_Q;    //Hold
        2'b01: master_Q <= 0;           //Reset
        2'b10: master_Q <= 1;           //Set
        2'b11: master_Q <= ~master_Q;   //Toggle
     endcase
   end
  
  //Slave latch 
  always@(negedge clk)begin
       Q <= master_Q;
       Qbar <= ~master_Q;
  end
endmodule
