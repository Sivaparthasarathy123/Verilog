// --------- 4-bit BCD Adder ------------
module bcd_adder (
    input  [3:0] A, B,
    input  Cin,
    output [3:0] Sum,
    output Cout
);

    wire [4:0] temp;
    wire carry;

    assign temp = A + B + Cin;
    assign carry = (temp > 9);

    assign Sum = carry ? temp + 6 : temp;
    assign Cout = carry;

endmodule

// Testbench
module bcd_adder_tb;

    reg  [3:0] A, B;
    reg  Cin;
    wire [3:0] Sum;
    wire Cout;

    bcd_adder DUT (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Sum(Sum),
        .Cout(Cout)
    );

    initial begin
      $monitor("A = %d B = %d Cin = %b -> Sum = %d Cout = %b",A, B, Cin, Sum, Cout);

        A = 4'd4; B = 4'd5; Cin = 0; #10;  // 9
        A = 4'd7; B = 4'd6; Cin = 0; #10;  // 13
        A = 4'd9; B = 4'd9; Cin = 0; #10;  // 18
        A = 4'd8; B = 4'd7; Cin = 1; #10;  // 16

        $finish;
    end
endmodule
