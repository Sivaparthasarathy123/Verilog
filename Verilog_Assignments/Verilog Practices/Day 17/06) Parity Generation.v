// 3) Design a memory-based parity checker. Store 16 data words in an array and use a function to calculate even parity for each word.

module memory_parity #(
  parameter WIDTH = 16,
  parameter DEPTH = 16
)(
  input clk,
  input rst,
  input [$clog2(DEPTH)-1:0]addr,
  input [WIDTH-1:0]data_in,
  output reg parity_out
);

  // memory
  reg [WIDTH-1:0] mem [0:DEPTH-1];

  // generation of even parity
  function int parity_gen;
    input [WIDTH-1:0] data;
    begin
      parity_gen = ~^data;  // even parity
    end
  endfunction

  always @(posedge clk) begin
    if(rst)begin
      parity_out <= 1'b0;
    end
    else begin
      mem[addr] <= data_in;

      // Check parity in Stored Data
      parity_out <= parity_gen(data_in);
    end
  end

endmodule

// Testbench

module memory_parity_tb;
  parameter WIDTH = 16;
  parameter DEPTH = 16;

  reg clk;
  reg rst;
  reg [$clog2(DEPTH)-1:0]addr;
  reg [WIDTH-1:0]data_in;
  wire parity_out;

  memory_parity #(.WIDTH(WIDTH),.DEPTH(DEPTH)) dut (clk ,rst ,addr ,data_in ,parity_out);

  reg parity_gen;
  reg expected_parity;

  initial clk = 0;
  always #5 clk = ~clk;

  // generation of even parity
  function int parity_calc;
    input [WIDTH-1:0] data;
    begin
      parity_calc = ~^data;  // even parity
    end
  endfunction

  // Reset Task
  task reset_dut;
    begin
      rst = 1;
      addr = 0;
      data_in = 0;
      #10;
      rst = 0;
    end
  endtask

  // Write and Applying Data
  task apply_data;
    input [3:0] a;
    input [WIDTH-1:0] d;
    begin
      @(posedge clk);
      addr    = a;
      data_in = d;
    end
  endtask

  // Task Checking Parity
  task check_parity;
    begin
      expected_parity = parity_calc(data_in);

      if (parity_out === expected_parity)
        $display("PASS data = %h expected = %b got = %b",data_in, expected_parity, parity_out);
      else
        $display("FAIL data = %h expected = %b got = %b",data_in, expected_parity, parity_out);
    end
  endtask

  initial begin
    $dumpfile("parity.vcd");
    $dumpvars;

    reset_dut;

    apply_data(4'd4, 16'b1010_1100_1111_0001);
    check_parity;

    apply_data(4'd7, 16'b1111_0000_1010_1010);
    check_parity;

    apply_data(4'd10, 16'b0000_1111_0000_1111);
    check_parity;

    #50 $finish;
  end

endmodule

