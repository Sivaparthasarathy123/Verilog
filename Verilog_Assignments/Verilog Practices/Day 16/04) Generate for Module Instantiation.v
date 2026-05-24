// Generate for Module Instantiation
module bit_inverter (
  input in,
  output out
);

  assign out = ~in;

endmodule

module generate_8_instances (
  input [7:0] in,
  output [7:0] out
);

  genvar i;

  generate
    for (i = 0; i < 8; i = i + 1) begin : GEN_INV
      bit_inverter u_inv (
        .in  (in[i]),
        .out (out[i])
      );
    end
  endgenerate

endmodule

// Testbench
module generate_8_instances_tb;

  reg [7:0] in;
  wire [7:0] out;

  reg [7:0] expected;

  generate_8_instances dut (
    .in  (in),
    .out (out)
  );

  initial begin
    $dumpfile("generate_8_instances.vcd");
    $dumpvars;

    in = 8'b0000_0000; #10;
    check_result();

    in = 8'b1111_1111; #10;
    check_result();

    in = 8'b1010_1010; #10;
    check_result();

    in = 8'b0101_0101; #10;
    check_result();

    in = 8'b1100_0011; #10;
    check_result();

    #20;
    $finish;
  end

  task check_result;
    begin
      expected = ~in;

      $display("Time = %0t | input = %b | output = %b | expected = %b",$time, in, out, expected);

      if (out == expected)
        $display("PASS");
      else
        $display("FAIL");
    end
  endtask

endmodule
