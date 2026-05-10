// parameterized N-bit adder
module nbit_adder #(
  parameter N = 4
)(
  input  [N-1:0] a,
  input  [N-1:0] b,
  input          cin,
  output [N-1:0] sum,
  output         cout
);

  assign {cout, sum} = a + b + cin;

endmodule

// Testbench
module nbit_adder_tb;

  parameter N = 8;

  reg  [N-1:0] a;
  reg  [N-1:0] b;
  reg          cin;

  wire [N-1:0] sum;
  wire         cout;

  reg  [N:0] expected;

  // DUT
  nbit_adder #(
    .N(N)
  ) dut (
    .a(a),
    .b(b),
    .cin(cin),
    .sum(sum),
    .cout(cout)
  );

  initial begin
    $dumpfile("nbit_adder.vcd");
    $dumpvars;

    $display("Time | a | b | cin | cout sum | expected");

    // Test 1
    a = 8'd10;
    b = 8'd20;
    cin = 1'b0;
    #10;
    check_result();

    // Test 2
    a = 8'd15;
    b = 8'd25;
    cin = 1'b1;
    #10;
    check_result();

    // Test 3: overflow or carry case
    a = 8'd255;
    b = 8'd1;
    cin = 1'b0;
    #10;
    check_result();

    // Test 4: max + max + cin
    a = 8'd255;
    b = 8'd255;
    cin = 1'b1;
    #10;
    check_result();

    // Test 5
    a = 8'd100;
    b = 8'd50;
    cin = 1'b0;
    #10;
    check_result();

    #20;
    $finish;
  end

  task check_result;
    begin
      expected = a + b + cin;

      $display("Time = %0t | A = %0d | B = %0d | Cin = %b | Cout = %b | Sum = %0d | Expected = %0d",$time, a, b, cin, cout, sum, expected);

      if ({cout, sum} == expected)
        $display("PASS");
      else
        $display("FAIL Expected = %b, Got = %b", expected, {cout, sum});
    end
  endtask

endmodule
