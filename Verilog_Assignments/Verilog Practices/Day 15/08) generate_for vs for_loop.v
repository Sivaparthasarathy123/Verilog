// generate_for vs for_loop 
module ripple_adder_generate #(
  parameter N = 4
)(
  input  [N-1:0] a,
  input  [N-1:0] b,
  input          cin,
  output [N-1:0] sum,
  output         cout
);

  wire [N:0] carry;

  assign carry[0] = cin;
  assign cout     = carry[N];

  genvar i;

  generate
    for (i = 0; i < N; i = i + 1) begin : GEN_FA
      full_adder u_fa (
        .a    (a[i]),
        .b    (b[i]),
        .cin  (carry[i]),
        .sum  (sum[i]),
        .cout (carry[i+1])
      );
    end
  endgenerate

endmodule

module parity_regular_for #(
  parameter N = 8
)(
  input  wire [N-1:0] data,
  output reg          parity
);

  integer j;

  always @(*) begin
    parity = 1'b0;

    for (j = 0; j < N; j = j + 1) begin
      parity = parity ^ data[j];
    end
  end

endmodule

// Testbench
module generate_vs_regular_for_tb;

  parameter N = 8;

  reg  [N-1:0] a;
  reg  [N-1:0] b;
  reg          cin;
  wire [N-1:0] sum;
  wire         cout;

  reg  [N-1:0] data;
  wire         parity;

  reg  [N:0] expected_sum;
  reg        expected_parity;

  ripple_adder_generate #(
    .N(N)
  ) dut_adder (
    .a(a),
    .b(b),
    .cin(cin),
    .sum(sum),
    .cout(cout)
  );

  parity_regular_for #(
    .N(N)
  ) dut_parity (
    .data(data),
    .parity(parity)
  );

  initial begin
    $dumpfile("generate_vs_regular_for.vcd");
    $dumpvars;

    $display("Testing generate for ripple adder");

    a = 8'd10; b = 8'd20; cin = 0; #10;
    check_adder();

    a = 8'd15; b = 8'd25; cin = 1; #10;
    check_adder();

    a = 8'd255; b = 8'd1; cin = 0; #10;
    check_adder();

    a = 8'd255; b = 8'd255; cin = 1; #10;
    check_adder();

    $display("Testing regular for parity logic");

    data = 8'b0000_0000; #10;
    check_parity();

    data = 8'b0000_0001; #10;
    check_parity();

    data = 8'b1010_1010; #10;
    check_parity();

    data = 8'b1111_1111; #10;
    check_parity();

    #20;
    $finish;
  end

  task check_adder;
    begin
      expected_sum = a + b + cin;

      $display("a = %0d b = %0d cin = %b | cout = %b sum = %0d | expected = %0d",a, b, cin, cout, sum, expected_sum);

      if ({cout, sum} == expected_sum)
        $display("ADDER PASS");
      else
        $display("ADDER FAIL");
    end
  endtask

  task check_parity;
    begin
      expected_parity = ^data;

      $display("data = %b | parity = %b | expected = %b",
               data, parity, expected_parity);

      if (parity == expected_parity)
        $display("PARITY PASS");
      else
        $display("PARITY FAIL");
    end
  endtask

endmodule
