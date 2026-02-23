// ---------- 4-bit Ripple Carry Adder ----------
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
  
// Testbench
module rca_4bit_tb;

    reg  [3:0] A, B;
    reg  Cin;
    wire [3:0] Sum;
    wire Cout;

    rca_4bit DUT (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Sum(Sum),
        .Cout(Cout)
    );

    initial begin
      $monitor("A = %b B = %b Cin = %b -> Sum = %b Cout = %b",A, B, Cin, Sum, Cout);

        A = 4'b0011; B = 4'b0101; Cin = 0; #10;
        A = 4'b1111; B = 4'b0001; Cin = 0; #10;
        A = 4'b1010; B = 4'b0101; Cin = 1; #10;
        A = 4'b1111; B = 4'b1111; Cin = 0; #10;

        $finish;
    end
endmodule
