// Asynchronous FIFO
module Asynchronous_fifo #(parameter DEPTH = 8, WIDTH = 8)(
  input w_clk, r_clk,
  input w_rst, r_rst,
  input w_en, r_en,
  input [WIDTH-1:0] data_in,
  output reg [WIDTH-1:0] data_out,
  output full, empty);

  localparam ADDR_WIDTH = $clog2(DEPTH); 
  reg [WIDTH-1:0] mem [0:DEPTH-1];

  reg [ADDR_WIDTH:0] wptr_bin, rptr_bin;
  reg [ADDR_WIDTH:0] wptr_gray, rptr_gray;
  reg [ADDR_WIDTH:0] wptr_sync2, rptr_sync2;
  reg [ADDR_WIDTH:0] wptr_sync1, rptr_sync1;

  // WRITE DOMAIN 
  always @(posedge w_clk or posedge w_rst) begin
    if (w_rst) begin
      wptr_bin  <= 0;
      wptr_gray <= 0;
    end 
    else if (w_en && !full) begin
      wptr_bin  <= wptr_bin + 1;
      wptr_gray <= (wptr_bin + 1) ^ ((wptr_bin + 1) >> 1);  
      mem[wptr_bin[ADDR_WIDTH-1:0]] <= data_in;
    end
  end

  // READ DOMAIN 
  always @(posedge r_clk or posedge r_rst) begin
    if (r_rst) begin
      rptr_bin  <= 0;
      rptr_gray <= 0;
      data_out  <= 0;
    end 
    else if (r_en && !empty) begin
      rptr_bin  <= rptr_bin + 1;
      rptr_gray <= (rptr_bin + 1) ^ ((rptr_bin + 1) >> 1);  
      data_out  <= mem[rptr_bin[ADDR_WIDTH-1:0]];
    end
  end

  // SYNCHRONIZERS (2-Stage) 
  always @(posedge w_clk or posedge w_rst) begin
    if (w_rst) 
    {rptr_sync2, rptr_sync1} <= 0;
    else       
    {rptr_sync2, rptr_sync1} <= {rptr_sync1, rptr_gray};
  end

  always @(posedge r_clk or posedge r_rst) begin
    if (r_rst)
    {wptr_sync2, wptr_sync1} <= 0;
    else
    {wptr_sync2, wptr_sync1} <= {wptr_sync1, wptr_gray};
  end

  // FULL & EMPTY
  assign empty = (rptr_gray == wptr_sync2);
  assign full  = (wptr_gray == {~rptr_sync2[ADDR_WIDTH:ADDR_WIDTH-1], rptr_sync2[ADDR_WIDTH-2:0]});

endmodule
