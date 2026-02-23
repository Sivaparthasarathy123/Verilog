// 4-bit Carry Lookahead Adder
module cla_4bit (
    input  [3:0] A,
    input  [3:0] B,
    input  Cin,
    output [3:0] Sum,
    output Cout
);

    wire [3:0] P, G;
    wire [4:0] C;

    assign C[0] = Cin;

    assign P = A ^ B;  // Propagate
    assign G = A & B;  // Generate

    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign C[4] = G[3] | (P[3] & C[3]);

    assign Sum = P ^ C[3:0];
    assign Cout = C[4];

endmodule

// Testbench
module cla_4bit_tb;

    reg  [3:0] A, B;
    reg  Cin;
    wire [3:0] Sum;
    wire Cout;

    cla_4bit DUT (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Sum(Sum),
        .Cout(Cout)
    );

    initial begin
      $monitor("A = %b B = %b Cin = %b -> Sum = %b Cout = %b",A, B, Cin, Sum, Cout);

        A = 4'd3;  B = 4'd5;  Cin = 0; #10;
        A = 4'd7;  B = 4'd8;  Cin = 0; #10;
        A = 4'd15; B = 4'd1;  Cin = 0; #10;
        A = 4'd9;  B = 4'd6;  Cin = 1; #10;

        $finish;
    end
endmodule
