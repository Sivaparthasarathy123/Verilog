// Asynchronous FIFO
module Asynchronous_fifo #(parameter DEPTH = 8, DATA_WIDTH = 8)(
   input w_clk, r_clk,
   input w_rst, r_rst,
   input w_en, r_en,
   input [DATA_WIDTH-1:0] data_in,
   output reg [DATA_WIDTH-1:0] data_out,
   output full, empty);

localparam addr = $clog2(DEPTH); //Total number of address bits

reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

//WRITE POINTER

reg [addr:0] w_ptr_bin, w_ptr_gray;

wire [addr:0] w_ptr_bin_next = w_ptr_bin + 1;
wire [addr:0] w_ptr_gray_next = (w_ptr_bin_next >> 1) ^ (w_ptr_bin_next);

always@(posedge w_clk)begin
   if(!w_rst)begin
      w_ptr_bin <= 0;
      w_ptr_gray <= 0;
   end
   else if(w_en && !full)begin
      w_ptr_bin <= w_ptr_bin_next;
      w_ptr_gray <= w_ptr_gray_next;
  end
end

//READ POINTER

reg [addr:0] r_ptr_bin, r_ptr_gray;

wire [addr:0] r_ptr_bin_next = r_ptr_bin + 1;
wire [addr:0] r_ptr_gray_next = (r_ptr_bin_next >> 1) ^ r_ptr_bin_next;

always@(posedge r_clk)begin
   if(!r_rst)begin
      r_ptr_bin <= 0;
      r_ptr_gray <= 0;
   end
   else if(r_en && !empty)begin
      r_ptr_bin <= r_ptr_bin_next;
      r_ptr_gray <= r_ptr_gray_next;
   end
end

// 2 - FF SYNCHRONIZER READ_PTR to WRITE_CLK_DOMAIN

reg [addr:0] rd_ptr_gray_sync1, rd_ptr_gray_sync2;

always@(posedge w_clk)begin
   if(!w_rst)begin
      rd_ptr_gray_sync1 <= 0;
      rd_ptr_gray_sync2 <= 0;
   end
   else begin
      rd_ptr_gray_sync1 <= r_ptr_gray;
      rd_ptr_gray_sync2 <= rd_ptr_gray_sync1;
  end
end

// 2 - FF SYNCHRONIZER WRITE_PTR to READ_CLK_DOMAIN

reg [addr:0] wr_ptr_gray_sync1, wr_ptr_gray_sync2;

always@(posedge r_clk)begin
   if(!r_rst)begin
      wr_ptr_gray_sync1 <= 0;
      wr_ptr_gray_sync2 <= 0;
   end
   else begin
      wr_ptr_gray_sync1 <= w_ptr_gray;
      wr_ptr_gray_sync2 <= wr_ptr_gray_sync1;
  end
end

// WRITE CONDITION

always@(posedge w_clk)
   if(w_en && !full)
    mem[w_ptr_bin[addr-1:0]] <= data_in;

// READ CONDITION

always@(posedge r_clk)
   if(r_en && !empty)
     data_out <= mem[r_ptr_bin[addr:0]];

// EMPTY CONDITION

assign empty = (r_ptr_gray == wr_ptr_gray_sync2);

// FULL CONDITION

assign full = (w_ptr_gray_next == {!rd_ptr_gray_sync2 [addr:addr-1], rd_ptr_gray_sync2[addr-2:0]});

endmodule

//testbench

`timescale 1ns/1ps

module asynchronous_fifo_tb();

parameter DEPTH = 16;
parameter DATA_WIDTH = 8;

reg w_clk, r_clk;
reg w_rst, r_rst;
reg w_en, r_en;
reg [DATA_WIDTH-1:0] data_in;
wire [DATA_WIDTH-1:0] data_out;
wire full, empty;


Asynchronous_fifo #(DEPTH, DATA_WIDTH) inst(w_clk, r_clk, w_rst, r_rst, w_en, r_en, data_in, data_out, full, empty);

// Clock Generation
initial begin
    w_clk = 0;
    r_clk = 0;
end

always #5  w_clk = ~w_clk;    
always #7  r_clk = ~r_clk;   


initial begin
    w_rst = 0;
    r_rst = 0;
    w_en = 0;
    r_en = 0;
    data_in = 0;

    #20;
    w_rst = 1;
    r_rst = 1;
end

integer i;

initial begin
    @(posedge w_rst);
    @(posedge w_clk);

  // WRITE 
  for(i=0;i<10;i++)begin
     @(posedge w_clk);
     if(!full)begin
       data_in = i;
       w_en = 1;
     $display("WRITE: %0d at time %0t", i, $time);
     end
  end
  w_en = 0;

  //READ
    #30;
    r_en = 1;

    // Read 10 values
    repeat(10)begin
      @(posedge r_clk);
        if(!empty)
        $display("READ : %0d at time %0t", data_out, $time);
    end

    r_en = 0;

    #100;
    $finish;
end

endmodule
