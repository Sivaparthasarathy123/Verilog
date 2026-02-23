// ---------- 8 bit Ripple Carry adder ------------
// 1-bit Full Adder
module full_adder (
    input  a, b, cin,
    output sum, cout
);
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule

// 8-bit Full Adder using generate
module rca_8bit (
    input  [7:0] A,
    input  [7:0] B,
    input  Cin,
    output [7:0] Sum,
    output Cout
);

    wire [8:0] carry;
    assign carry[0] = Cin;

    genvar i;
    generate
        for(i=0; i<8; i=i+1) begin : FA8
            full_adder FA (
                .a(A[i]),
                .b(B[i]),
                .cin(carry[i]),
                .sum(Sum[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate

    assign Cout = carry[8];

endmodule

// Testbench
module rca_8bit_tb;

    reg  [7:0] A, B;
    reg  Cin;
    wire [7:0] Sum;
    wire Cout;

    rca_8bit DUT (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Sum(Sum),
        .Cout(Cout)
    );

    initial begin
      $monitor("A = %b B = %b Cin = %b -> Sum = %b Cout = %b", A, B, Cin, Sum, Cout);

        A = 8'd15;  B = 8'd10;  Cin = 0; #10;
        A = 8'd255; B = 8'd1;   Cin = 0; #10;
        A = 8'd100; B = 8'd50;  Cin = 1; #10;
        A = 8'd200; B = 8'd100; Cin = 0; #10;

        $finish;
    end
endmodule
