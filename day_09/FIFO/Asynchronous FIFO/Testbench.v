// Testbench
`timescale 1ns/1ps

module asynchronous_fifo_tb();

  parameter DEPTH = 8;
  parameter WIDTH = 8;

  reg w_clk, r_clk;
  reg w_rst, r_rst;
  reg w_en, r_en;
  reg [WIDTH-1:0] data_in;
  wire [WIDTH-1:0] data_out;
  wire full, empty;
  integer i;
  
  Asynchronous_fifo #(DEPTH, WIDTH) fifo(
    .w_clk(w_clk), 
    .r_clk(r_clk),
    .w_rst(w_rst), 
    .r_rst(r_rst),
    .w_en(w_en), 
    .r_en(r_en),
    .data_in(data_in), 
    .data_out(data_out),
    .full(full), 
    .empty(empty)
  );

  initial begin
    w_clk = 0;
    forever #5 w_clk = ~w_clk;  
  end

  initial begin
    r_clk = 0;
    forever #10 r_clk = ~r_clk;  
  end

  initial begin

    w_rst = 1; 
    r_rst = 1; 
    w_en = 0; 
    r_en = 0; 
    data_in = 0;
    #20 w_rst = 0; r_rst = 0;
    #10;

    $display("------------ FIFO TEST START --------------");

    // Write test
    for(i=1; i<=4; i=i+1) begin
      @(posedge w_clk);
      w_en = 1;
      data_in = i * 10;  
    end
    w_en = 0;

    // Read test
    for(i=1; i<=4; i=i+1) begin
      @(posedge r_clk);
      r_en = 1;
      #1;  
    end
    r_en = 0;

    // Making FIFO Full
    $display("\n--- WRITE DATA UNTIL FULL---");
    while(full == 0) begin
      @(posedge w_clk);
      w_en = 1;
      data_in = data_in + 1;
      $display("Time = %0t | Write = %0d | Full = %0b", $time, data_in, full);
    end
    w_en = 0;
    $display("FIFO IS FULL");

    // Making FIFO EMPTY
    $display("\n--- READ DATA UNTIL EMPTY ---");
    while(empty == 0) begin
      @(posedge r_clk);
      r_en = 1;
      #1;
      $display("Time = %0t | Read = %0d | Empty = %0b", $time, data_out, empty);
    end
    r_en = 0;
    $display("FIFO IS EMPTY");

    // TEST STARTED
    $display("\n---------- REPEAT TEST -------------");

    // Write 2 numbers
    repeat(2) begin
      @(posedge w_clk);
      w_en = 1;
      data_in = $random;
      $display("Write = %0d", data_in);
    end

    // Read 1 number
    fork
      begin
        @(posedge r_clk); 
        r_en = 1; 
        #1; 
        $display("Read = %0d", data_out); 
        r_en = 0;
      end
      begin
        @(posedge w_clk); 
        w_en = 1; 
        data_in = 99; 
        $display("Write = 99"); 
        w_en = 0;
      end
    join

    $display("\n------- FIFO TEST DONE ------------");
    #50 $finish;
  end

  initial begin
    $dumpfile("fifo.vcd");
    $dumpvars(0, asynchronous_fifo_tb);
  end

endmodule
