module dual_port_ram #(parameter DEPTH = 16, WIDTH = 16)(
    input clk,
    input rst,                      
    input w_en_a, w_en_b,
    input [$clog2(DEPTH)-1:0] addr_a, addr_b,
    input [WIDTH-1:0] data_in_a, data_in_b,
    output reg [WIDTH-1:0] data_out_a, data_out_b
);

reg [WIDTH-1:0] mem [0:DEPTH-1];

always @(posedge clk) begin
    if (rst) begin
        data_out_a <= 0;
        data_out_b <= 0;
    end else begin
        // PORT A Logic
        if(w_en_a)
            mem[addr_a] <= data_in_a;
        else
            data_out_a <= mem[addr_a];

        // PORT B Logic
        if(w_en_b)
            mem[addr_b] <= data_in_b;
        else
            data_out_b <= mem[addr_b];
    end
end

endmodule

// testbench

`timescale 1ns/1ps

module dual_port_ram_tb;
  parameter DEPTH = 16;
  parameter WIDTH = 16;

  reg clk, w_en_a, w_en_b;
  reg [$clog2(DEPTH)-1:0] addr_a, addr_b;
  reg [WIDTH-1:0] data_in_a, data_in_b;
  wire [WIDTH-1:0] data_out_a, data_out_b;

  reg [WIDTH-1:0] mem_a [0:DEPTH-1];
  reg [WIDTH-1:0] mem_b [0:DEPTH-1];

  integer i;

  dual_port_ram #(.DEPTH(DEPTH),.WIDTH(WIDTH)) inst (clk, w_en_a, w_en_b, addr_a, addr_b, data_in_a, data_in_b, data_out_a, data_out_b);

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    // WRITE DATA
    w_en_a = 1;
    w_en_b = 1;

    for(i=0;i<DEPTH;i++)begin
      addr_a = i;
      addr_b = i;
      
      data_in_a = $random;
      data_in_b = $random;

      mem_a[i] = data_in_a;
      mem_b[i] = data_in_b;

      @(posedge clk);
      #1;

      $display("WRITE TIME=%0t | A: addr=%0d data=%0h | B: addr=%0d data=%0h",$time, addr_a, data_in_a, addr_b, data_in_b);
    end

    // READ DATA
    w_en_a = 0;
    w_en_b = 0;

    for(i=0;i<DEPTH;i++)begin
      addr_a = i;
      addr_b = i;

      @(posedge clk);
      #1;

      $display("READ  TIME=%0t | A: addr=%0d data=%0h (exp=%0h) | B: addr=%0d data=%0h (exp=%0h)",$time, addr_a, data_out_a, mem_a[i],addr_b, data_out_b, mem_b[i]);

      if(data_out_a !== mem_a[i])
        $display("ERROR at A[%0d]: got=%0h expected=%0h", i, data_out_a, mem_a[i]);

      if(data_out_b !== mem_b[i])
        $display("ERROR at B[%0d]: got=%0h expected=%0h", i, data_out_b, mem_b[i]);
    end

    #50 $finish;
  end

endmodule

