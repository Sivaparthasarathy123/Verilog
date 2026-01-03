//Synchronous FIFO
module synchronous_FIFO #(parameter DEPTH = 8, DATA_WIDTH = 8)(
  input clk, rst_n,
  input w_en, r_en,
  input [DATA_WIDTH-1:0] data_in,
  output reg [DATA_WIDTH-1:0] data_out,
  output reg full, empty);

reg [DEPTH-1:0] w_ptr,r_ptr;
reg [DATA_WIDTH-1:0] fifo[DEPTH];

always@(posedge clk)begin
  if(!rst_n)begin
  w_ptr = 0;
  r_ptr = 0;
  data_out = 0;
  end
end

always@(posedge clk)begin
  if(w_en & !full)begin
    fifo[w_ptr] <= data_in;
     w_ptr <= w_ptr + 1;
    end
  end
always@(posedge clk)begin
   if(r_en & !empty)begin
      data_out <= fifo[r_ptr];
      r_ptr <= r_ptr + 1;
    end
  end
  
  assign full = ((w_ptr+1'b1) == r_ptr);
  assign empty = (w_ptr == r_ptr);
endmodule

//testbench

`timescale 1ns/1ps

module synchronous_FIFO_tb;

parameter DEPTH = 8;
parameter DATA_WIDTH = 8;

reg clk, rst_n;
reg w_en, r_en;
reg [DATA_WIDTH-1:0] data_in;
wire [DATA_WIDTH-1:0] dta_out;
wire full, empty;

synchronous_FIFO #(DEPTH, DATA_WIDTH) inst (clk,rst_n,w_en,r_en,data_in,data_out,full,empty);

always #5 clk = ~clk;

initial begin
clk = 0;
rst_n = 0;
w_en = 0;
r_en = 0;
data_in = 0;

#10; rst_n = 1;

repeat(6)begin
  @(posedge clk);
if(!full)begin
  w_en = 1;
  data_in = $random;
  $display("Write: data_in = %0d at time %0t",$time, data_in);
end
end
w_en = 0;

#20;
repeat(6)begin
  @(posedge clk);
  if(!empty)begin
   r_en = 1;
   $display("Read: data_out = %0d at time %0t",$time, data_out);
end
end
r_en = 0;

#50; $finish;
end
endmodule



                  
    
  
