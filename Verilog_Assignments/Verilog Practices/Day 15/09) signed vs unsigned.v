// signed vs unsigned
module mixed_signed_unsigned_wrong (
  input  wire signed [7:0] a,
  input  wire        [7:0] b,
  output wire signed [8:0] result
);

  assign result = a + b;

endmodule

module mixed_signed_unsigned_correct (
  input  wire signed [7:0] a,
  input  wire        [7:0] b,
  output wire signed [8:0] result
);

  assign result = $signed(a) + $signed(b);

endmodule

module signed_adder_safe (
  input  wire signed [7:0] a,
  input  wire signed [7:0] b,
  output wire signed [8:0] result
);

  assign result = {a[7], a} + {b[7], b};

endmodule

// Testbench
module signed_unsigned_tb;

  reg signed [7:0] a;
  reg        [7:0] b_unsigned;
  reg signed [7:0] b_signed;

  wire signed [8:0] result_wrong;
  wire signed [8:0] result_correct;
  wire signed [8:0] result_safe;

  reg signed [8:0] expected;

  // mixed signed + unsigned
  mixed_signed_unsigned_wrong u_wrong (
    .a(a),
    .b(b_unsigned),
    .result(result_wrong)
  );

  // using $signed casting
  mixed_signed_unsigned_correct u_correct (
    .a(a),
    .b(b_unsigned),
    .result(result_correct)
  );

  // both operands signed and sign extended
  signed_adder_safe u_safe (
    .a(a),
    .b(b_signed),
    .result(result_safe)
  );

  initial begin
    $dumpfile("signed_unsigned.vcd");
    $dumpvars;

    $display("Time | a | b_unsigned | wrong | correct | safe | expected");

    // Test 1: negative + positive
    a = -8'sd5;
    b_unsigned = 8'd3;
    b_signed   = 8'sd3;
    expected   = -9'sd2;
    #10;
    check_result();

    // Test 2: negative + positive
    a = -8'sd10;
    b_unsigned = 8'd4;
    b_signed   = 8'sd4;
    expected   = -9'sd6;
    #10;
    check_result();

    // Test 3: positive + positive
    a = 8'sd20;
    b_unsigned = 8'd10;
    b_signed   = 8'sd10;
    expected   = 9'sd30;
    #10;
    check_result();

    // Test 4: negative + larger positive
    a = -8'sd20;
    b_unsigned = 8'd50;
    b_signed   = 8'sd50;
    expected   = 9'sd30;
    #10;
    check_result();

    // Test 5: signed negative value in b
    a = 8'sd5;
    b_unsigned = 8'b1111_1100;
    b_signed   = 8'sb1111_1100;
    expected   = 9'sd1;
    #10;
    check_result();

    #20;
    $finish;
  end

  task check_result;
    begin
      $monitor("Time = %t | a = %d | b_unsigned = %0d | result_wrong = %0d | result_correct = %0d | result_safe = %0d | expected = %0d"
               ,$time ,a ,b_unsigned ,result_wrong ,result_correct, result_safe,
               expected);

      if (result_safe == expected)
        $display("SAFE RESULT PASS");
      else
        $display("SAFE RESULT FAIL");

      if (result_correct == expected)
        $display("CAST RESULT PASS");
      else
        $display("CAST RESULT FAIL");

      if (result_wrong != expected)
        $display("WRONG DESIGN SHOWS MISMATCH");
      else
        $display("WRONG DESIGN MATCHED FOR THIS CASE");
    end
  endtask

endmodule
