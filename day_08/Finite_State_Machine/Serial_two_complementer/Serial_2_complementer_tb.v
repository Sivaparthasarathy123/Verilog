// Serial 2 Complementer Testbench 
`timescale 1ns/1ps
module Serial_2_complementer_tb();
   reg clk,reset,x;
   wire q;

Serial_2_complementer inst(clk,reset,x,q);

   initial clk = 0;
   always #5 clk = ~clk;

   initial begin
       $monitor("%0t|clk=%b|reset=%b|bx=%b|q=%b",$time,clk,reset,x,q);
       $dumpfile("2_comp.vcd");
       $dumpvars;
  
       reset = 1; x = 0;
       #10 reset = 0;
       #10 x=1;
       #10 x=1;
       #10 x=0;
       $finish;
   end
endmodule 

