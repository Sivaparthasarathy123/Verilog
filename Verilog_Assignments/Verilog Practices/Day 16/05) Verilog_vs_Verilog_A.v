// Verilog_vs_Verilog_A

// Verilog RTL Synthesizable Code
module digital_inverter (
  input  a,
  output y
);

  assign y = ~a;

endmodule

// Testbench
module digital_inverter_tb;

  reg a;
  wire y;

  digital_inverter dut (
    .a(a),
    .y(y)
  );

  initial begin
    $dumpfile("digital_inverter.vcd");
    $dumpvars;

    $display("Time | a | y");

    a = 0; #10;
    $display("%0t | %b | %b", $time, a, y);

    a = 1; #10;
    $display("%0t | %b | %b", $time, a, y);

    a = 0; #10;
    $display("%0t | %b | %b", $time, a, y);

    #10;
    $finish;
  end

endmodule

// Verilog A Non Synthesizable code
`include "disciplines.vams"
// This is not simulated it's just for example
module resistor(p, n);
  inout p, n;
  electrical p, n;

  parameter real R = 1000.0;

  analog begin
    V(p, n) <+ R * I(p, n);
  end
endmodule

// Verilo A Testbench
`include "disciplines.vams"

module resistor_tb;
  electrical p, n;

  resistor #(.R(1000.0)) dut (
    .p(p),
    .n(n)
  );

  analog begin
    V(p, n) <+ 1.0;
  end
endmodule
