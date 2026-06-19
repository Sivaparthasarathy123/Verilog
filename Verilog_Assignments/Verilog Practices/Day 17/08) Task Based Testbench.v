// 4) Design a task-based testbench for a register file. Include write, read, reset, and data comparison tasks.

module register_file #(
  parameter WIDTH = 8,
  parameter DEPTH = 16
)(
  input clk,
  input rst,
  input we,
  input re,
  input [$clog2(DEPTH)-1:0]wr_addr,
  input [$clog2(DEPTH)-1:0]rd_addr,
  input [WIDTH-1:0]data_in,
  output reg [WIDTH-1:0]data_out
);

  integer i;

  reg [WIDTH-1:0] mem [0:DEPTH-1];

  // Write & Reset
  always @(posedge clk) begin
    if(rst) begin
      for(i=0;i<DEPTH;i=i+1)
        mem[i] <= 0;
    end
    else if(we) begin
      mem[wr_addr] <= data_in;
    end
  end

  // Read
  always @(*) begin
    if(re)
      data_out = mem[rd_addr];
    else
      data_out = 0;
  end

endmodule

// Testbench
`timescale 1ns/1ps

module register_file_tb;

  parameter WIDTH = 8;
  parameter DEPTH = 16;

  reg clk;
  reg rst;
  reg we;
  reg re;

  reg [$clog2(DEPTH)-1:0] wr_addr;
  reg [$clog2(DEPTH)-1:0] rd_addr;

  reg [WIDTH-1:0] data_in;
  wire [WIDTH-1:0] data_out;

  register_file #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH)
  ) dut (
    .clk(clk),
    .rst(rst),
    .we(we),
    .re(re),
    .wr_addr(wr_addr),
    .rd_addr(rd_addr),
    .data_in(data_in),
    .data_out(data_out)
  );

  always #5 clk = ~clk;

  reg [WIDTH-1:0] expected_mem [0:DEPTH-1];

  integer pass_count;
  integer fail_count;
  integer i;

  // Reset Task
  task reset_dut;
    begin
      $display("\nApplying Reset");

      rst = 1;
      we  = 0;
      re  = 0;

      repeat(2) @(posedge clk);

      rst = 0;

      for(i=0;i<DEPTH;i=i+1)
        expected_mem[i] = 0;

      $display("Reset Completed");
    end
  endtask

  // Write Task
  task write_reg(
    input [$clog2(DEPTH)-1:0] addr,
    input [WIDTH-1:0] data
  );
    begin

      @(posedge clk);

      we      = 1;
      re      = 0;
      wr_addr = addr;
      data_in = data;

      expected_mem[addr] = data;

      @(posedge clk);

      we = 0;

      $display("WRITE Addr = %0d Data = %0h", addr,data);
    end
  endtask

  // Read Task
  task read_reg(
    input [$clog2(DEPTH)-1:0] addr,
    output [WIDTH-1:0] data
  );
    begin

      re      = 1;
      rd_addr = addr;

      #1;

      data = data_out;

      re = 0;

      $display("READ Addr = %0d Data = %0h", addr,data);
    end
  endtask

  // Compare Task
  task compare_data(
    input [$clog2(DEPTH)-1:0] addr);

    reg [WIDTH-1:0] actual;
    reg [WIDTH-1:0] expected;

    begin

      read_reg(addr, actual);

      expected = expected_mem[addr];

      if(actual === expected)begin
        pass_count = pass_count + 1;

        $display("PASS Addr = %0d Expected = %0h Actual = %0h", addr,expected,actual);
      end
      else begin
        fail_count = fail_count + 1;

        $display("FAIL Addr = %0d Expected = %0h Actual = %0h", addr,expected,actual);
      end

    end
  endtask

  // Sequence Test
  initial begin

    clk = 0;

    rst = 0;
    we  = 0;
    re  = 0;

    wr_addr = 0;
    rd_addr = 0;

    data_in = 0;

    pass_count = 0;
    fail_count = 0;

    // Reset 
    reset_dut();

    // Write
    write_reg(4,8'hAA);
    write_reg(7,8'h55);
    write_reg(10,8'hF0);
    write_reg(15,8'h3C);

    // Compare & Read
    compare_data(4);
    compare_data(7);
    compare_data(10);
    compare_data(15);

    // Final
    $display("PASS = %0d",pass_count);
    $display("FAIL = %0d",fail_count);

    if(fail_count == 0)
      $display("TEST PASSED");
    else
      $display("TEST FAILED");

    #20;
    $finish;

  end

endmodule
