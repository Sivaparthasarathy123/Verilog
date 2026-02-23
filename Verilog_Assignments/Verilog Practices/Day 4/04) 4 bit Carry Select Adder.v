// --------- 4 bit Carry Select Adder ------------
// 1-bit Full Adder
module full_adder (
    input  a, b, cin,
    output sum, cout
);
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule

// 4-bit Ripple Carry Adder using generate
module rca_4bit (
    input  [3:0] A,
    input  [3:0] B,
    input  Cin,
    output [3:0] Sum,
    output Cout
);

    wire [4:0] carry;
    assign carry[0] = Cin;

    genvar i;
    generate
        for(i=0; i<4; i=i+1) begin : FA_BLOCK
            full_adder FA (
                .a(A[i]),
                .b(B[i]),
                .cin(carry[i]),
                .sum(Sum[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate

    assign Cout = carry[4];

endmodule

// Carry Select Adder
module carry_select_4bit (
    input  [3:0] A, B,
    input  Cin,
    output [3:0] Sum,
    output Cout
);

    wire [3:0] sum0, sum1;
    wire c0, c1;

    // Cin = 0
    rca_4bit RCA0 (.A(A), .B(B), .Cin(0), .Sum(sum0), .Cout(c0));

    // Cin = 1
    rca_4bit RCA1 (.A(A), .B(B), .Cin(1), .Sum(sum1), .Cout(c1));

    assign Sum  = (Cin) ? sum1 : sum0;
    assign Cout = (Cin) ? c1   : c0;

endmodule

// Testbench
module carry_select_4bit_tb;

    reg  [3:0] A, B;
    reg  Cin;
    wire [3:0] Sum;
    wire Cout;

    carry_select_4bit DUT (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Sum(Sum),
        .Cout(Cout)
    );

    initial begin
      $monitor("A = %b B = %b Cin = %b -> Sum = %b Cout = %b",
                  A, B, Cin, Sum, Cout);

        A = 4'd4;  B = 4'd3;  Cin = 0; #10;
        A = 4'd4;  B = 4'd3;  Cin = 1; #10;
        A = 4'd15; B = 4'd1;  Cin = 0; #10;
        A = 4'd10; B = 4'd5;  Cin = 1; #10;

        $finish;
    end
endmodule
