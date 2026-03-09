// Testbench 
`timescale 1ns/1ps
module synchronous_FIFO_tb;

  parameter DEPTH = 8;
  parameter DATA_WIDTH = 8;

  reg clk, rst_n;
  reg w_en, r_en;
  reg [DATA_WIDTH-1:0] data_in;
  wire [DATA_WIDTH-1:0] data_out;
  wire full, empty;
  integer i;

  synchronous_FIFO #(DEPTH, DATA_WIDTH) inst (
    .clk(clk), 
    .rst_n(rst_n),
    .w_en(w_en), 
    .r_en(r_en),
    .data_in(data_in), 
    .data_out(data_out),
    .full(full), 
    .empty(empty)
  );

  always #5 clk = ~clk;

  initial begin
    clk = 0;
    rst_n = 0; 
    w_en = 0; 
    r_en = 0; 
    data_in = 0;
    
    #15;
    rst_n = 1;  
    #10;

    
    $display(" --------- FIFO TEST STARTED ---------");
    
    // Write values
    $display("\n--- Writing values ---");
    for(i=1; i<=4; i=i+1) begin
      @(posedge clk);
      w_en = 1;
      data_in = i * 10;
      $display("Time = %0t data = %0d, full = %b, empty = %b", $time, data_in, full, empty);
    end
    w_en = 0;
    
    // Read values
    $display("\n--- Reading values ---");
    for(i=1; i<=4; i=i+1) begin
      @(posedge clk);
      r_en = 1;
      #1;  
      $display("Time = %0t data = %0d, full = %b, empty = %b", $time, data_out, full, empty);
    end
    r_en = 0;
    
    // Fill FIFO completely
    $display("\n------------- Fill FIFO --------------");
    for(i=1; i<=DEPTH; i=i+1) begin
      @(posedge clk);
      w_en = 1;
      data_in = i + 100;
      $display("data = %0d, full = %b, empty = %b", data_in, full, empty);
    end
    w_en = 0;
    $display("----------- FIFO FULL -> %0b  ---------", full);
    
    // Empty FIFO completely
    $display("\n--- Empty FIFO ---");
    for(i=1; i<=DEPTH; i=i+1) begin
      @(posedge clk);
      r_en = 1;
      #1;
      $display("data=%0d, full=%b, empty=%b", data_out, full, empty);
    end
    r_en = 0;
    $display("------------- FIFO EMPTY -> %0b ---------", empty);
   
    $display("\n--------------- WRITE & READ -----------------");
    
    // First write 
    @(posedge clk);
    w_en = 1;
    data_in = 200;
    $display("WRITE: %0d", data_in);
    w_en = 0;
    
    // Write and Read
    fork
      begin
        @(posedge clk);
        w_en = 1;
        data_in = 300;
        $display("WRITE -> %0d", data_in);
        w_en = 0;
      end
      begin
        @(posedge clk);
        r_en = 1;
        #1;
        $display("READ -> %0d", data_out);
        r_en = 0;
      end
    join
    
    $display("------- FIFO TEST COMPLETED ------------");
    
    #50;
    $finish;
  end

  // Generate waveform
  initial begin
    $dumpfile("fifo.vcd");
    $dumpvars(0, synchronous_FIFO_tb);
  end

endmodule
