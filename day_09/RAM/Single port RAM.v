//Single port RAM
module single_port_RAM #(
    parameter DEPTH = 8, 
    parameter WIDTH = 8
)(
    input clk, 
    input w_en, 
    input [$clog2(DEPTH)-1:0] addr, 
    input [WIDTH-1:0] data_in,
    output reg [WIDTH-1:0] data_out
);

    // Memory array
    reg [WIDTH-1:0] mem [0:DEPTH-1];
  
    always @(posedge clk) begin
        if (w_en) begin
            mem[addr] <= data_in;
        else
            data_out <= mem[addr]; 
    end

endmodule

//testbench

`timescale 1ns/1ps

module single_port_RAM_tb;
  parameter DEPTH = 8;
  parameter WIDTH = 8;

  reg clk, w_en;
  reg [$clog(DEPTH)-1:0] addr;      
  reg [WIDTH-1:0] data_in;
  wire [WIDTH-1:0] data_out;
  
  integer i;
  reg [WIDTH-1:0] mem [0:DEPTH-1]; 

  single_port_RAM #(.DEPTH(DEPTH),.WIDTH(WIDTH)) inst(clk, w_en, addr, data_in, data_out);

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    // WRITE DATA
    w_en = 1;
    for(i=0;i<DEPTH;i++)begin
      addr = i;              
      data_in = $random;
      mem[i] = data_in;   
      @(posedge clk);         
      #1;              
      $display("WRITE: time=%0t addr=%0d data_in=%0h", $time, addr, data_in);
    end

    // READ DATA
    w_en=0;
    for(i=0;i<DEPTH;i++)begin
      addr = i;               
      @(posedge clk);         
      #1;                     
      $display("READ : time=%0t addr=%0d data_out=%0h expected=%0h",$time, addr, data_out, mem[i]);
      
      if(data_out !== mem[i])begin
        $display("ERROR: mismatch at addr %0d (got %0h, exp %0h)", i, data_out, mem[i]);
      end
    end

    #100 $finish;
  end

endmodule
    
    
